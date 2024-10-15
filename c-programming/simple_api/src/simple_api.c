#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <microhttpd.h>
#include <cjson/cJSON.h>

#define PORT 8888

// Callback function to handle HTTP requests
static int answer_to_connection(void *cls, struct MHD_Connection *connection, 
                                const char *url, const char *method, 
                                const char *version, const char *upload_data, 
                                size_t *upload_data_size, void **con_cls) {
    if (strcmp(method, "GET") == 0) {
        // Create a simple JSON object
        cJSON *json = cJSON_CreateObject();
        cJSON_AddStringToObject(json, "message", "Hello, World!");
        cJSON_AddNumberToObject(json, "code", 200);

        // Convert JSON object to string
        char *json_string = cJSON_Print(json);
        int response_code = MHD_HTTP_OK;

        // Send the response
        struct MHD_Response *response = MHD_create_response_from_buffer(strlen(json_string), 
                                  (void *)json_string, MHD_RESPMEM_MUST_COPY);
        MHD_add_response_header(response, "Content-Type", "application/json");
        
        int ret = MHD_queue_response(connection, response_code, response);
        MHD_destroy_response(response);
        free(json_string);
        cJSON_Delete(json);
        
        return ret;
    }

    // Method not allowed for other HTTP methods
    return MHD_queue_response(connection, MHD_HTTP_METHOD_NOT_ALLOWED, 
                              MHD_create_response_from_buffer(0, NULL, MHD_RESPMEM_PERSISTENT));
}

int main() {
    struct MHD_Daemon *daemon;

    // Start the HTTP server
    daemon = MHD_start_daemon(MHD_USE_SELECT_INTERNALLY, PORT, NULL, NULL,
                              &answer_to_connection, NULL, MHD_OPTION_END);
    if (daemon == NULL) return 1;

    // Wait for a signal to terminate
    printf("Server is running on port %d...\n", PORT);
    getchar(); // Wait for Enter key to stop

    MHD_stop_daemon(daemon);
    return 0;
}
