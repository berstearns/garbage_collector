#!/bin/bash

set -e

# Set variables
BUCKET_NAME="duo-clone"
PUBLIC_DIR="./duolingo-clone-pwa/public"
CLOUDFRONT_DIST_ID_FILE="cloudfront_distribution_id.txt"
REGION="us-east-1"  # Specify your region

# Function to check if a command succeeded
check_command() {
  if [ $? -ne 0 ]; then
    echo "Error: $1 failed. Exiting script."
    exit 1
  fi
}

# Check if the S3 bucket exists
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "S3 bucket $BUCKET_NAME already exists."
else
  echo "Creating S3 bucket $BUCKET_NAME..."
  aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" 
  check_command "Bucket creation"

  echo "Waiting for bucket to be created..."
  aws s3api wait bucket-exists --bucket "$BUCKET_NAME"
  check_command "Waiting for bucket creation"
  echo "S3 bucket $BUCKET_NAME created successfully."
fi

# Sync public folder to S3 bucket
echo "Syncing $PUBLIC_DIR to S3 bucket s3://$BUCKET_NAME..."
aws s3 sync $PUBLIC_DIR s3://$BUCKET_NAME --delete
check_command "Syncing files to S3"

# Set S3 bucket policy to allow public read access
echo "Setting S3 bucket policy for public read access..."
aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::'$BUCKET_NAME'/*"
    }
  ]
}'
check_command "Setting bucket policy"

# Configure S3 bucket as a static website
echo "Configuring S3 bucket for static website hosting..."
aws s3 website s3://$BUCKET_NAME/ --index-document index.html --error-document index.html
check_command "Configuring S3 website"

# Create CloudFront distribution if it doesn't exist
if [ ! -f $CLOUDFRONT_DIST_ID_FILE ]; then
  echo "Creating CloudFront distribution..."
  CLOUDFRONT_DIST_ID=$(aws cloudfront create-distribution --origin-domain-name "$BUCKET_NAME.s3.amazonaws.com" --default-root-object index.html --output json | jq -r '.Distribution.Id')
  check_command "Creating CloudFront distribution"

  # Save CloudFront distribution ID for future updates
  echo $CLOUDFRONT_DIST_ID > $CLOUDFRONT_DIST_ID_FILE
else
  # Load existing CloudFront distribution ID
  CLOUDFRONT_DIST_ID=$(cat $CLOUDFRONT_DIST_ID_FILE)
fi

# Invalidate CloudFront cache to reflect new changes
echo "Invalidating CloudFront cache..."
aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DIST_ID --paths "/*"
check_command "Invalidating CloudFront cache"

# Output the CloudFront URL
CLOUDFRONT_DOMAIN=$(aws cloudfront get-distribution --id $CLOUDFRONT_DIST_ID --output json | jq -r '.Distribution.DomainName')
check_command "Retrieving CloudFront distribution info"
echo "Deployment complete! Your site is available at https://$CLOUDFRONT_DOMAIN"

