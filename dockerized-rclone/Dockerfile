FROM debian:bookworm-20241223
RUN apt update && apt install -y \
				curl\
				unzip
COPY ./install_rclone.sh /install_rclone.sh
RUN chmod +x /install_rclone.sh
RUN /install_rclone.sh
# FROM rclone/rclone:1.69
