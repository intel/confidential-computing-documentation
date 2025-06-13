---
description: Data structures used in SGX multi-package registration and attestation.
keywords: Intel SGX, DCAP, data structures, multi-package, registration
---
<!---
Copyright (C) 2025 Intel Corporation
SPDX-License-Identifier: CC-BY-4.0
-->

# Data Structures


## Common Data Structures

- Result codes returned by the API's in the UEFI and Network libraries

    ``` {.text}
    typedef enum {
        MP_SUCCESS = 0,
        MP_NO_PENDING_DATA = 1,
        MP_ALREADY_REGISTERED = 2,
        MP_MEM_ERROR = 3,
        MP_UEFI_INTERNAL_ERROR = 4,
        MP_USER_INSUFFICIENT_MEM = 5,
        MP_INVALID_PARAMETER = 6,
        MP_SGX_NOT_SUPPORTED = 7,
        MP_UNEXPECTED_ERROR = 8,
        MP_REDUNDANT_OPERATION = 9,
        MP_NETWORK_ERROR = 10,
        MP_NOT_INITIALIZED = 11,
        MP_INSUFFICIENT_PRIVILEGES = 12
    } MpResult;
    ```

- Supported logging levels

    ``` {.text}
    typedef enum _LogLevel{
        MP_REG_LOG_LEVEL_NONE = 0,
        MP_REG_LOG_LEVEL_FUNC = 1,
        MP_REG_LOG_LEVEL_ERROR = 2,
        MP_REG_LOG_LEVEL_INFO = 3,
        MP_REG_LOG_LEVEL_MAX_VALUE
    } LogLevel;
    ```

- Supported types of data structures in the [`SgxRegistrationServerRequest`][request] UEFI variable

    ``` {.text}
    typedef enum {
        MP_REQ_REGISTRATION = 0,
        MP_REQ_ADD_PACKAGE = 1,
        MP_REQ_NONE = 2
    } MpRequestType;
    ```

- These are the possible error codes reported by the agent in the [`SgxRegistrationStatus`][status] UEFI variable in the `ErrorCode` field

    ``` {.text}
    typedef enum _RegistrationErrorCode{
        MPA_SUCCESS = 0x00,
        MPA_AG_UNEXPECTED_ERROR = 0x80,     // Unexpected agent internal error.
        MPA_AG_OUT_OF_MEMORY = 0x81,        // Out-of-memory error.
        MPA_AG_NETWORK_ERROR = 0x82,        // Proxy detection or network
                                            // communication error
        MPA_AG_INVALID_PARAMETER = 0x83,    // Invalid Parameter passed in
        MPA_AG_INTERNAL_SERVER_ERROR = 0x84, // Internal server error occurred.
        MPA_AG_SERVER_TIMEOUT = 0x85,       // Server timeout reached
        MPA_AG_BIOS_PROTOCOL_ERROR = 0x86,  // BIOS Protocol error

        /* Registration Server HTTP 400 Response Error details */
        MPA_RS_INVALID_REQUEST_SYNTAX = 0xA0, // The request could not be
                                            // understood by the server due to
                                            // malformed syntax.
        MPA_RS_PM_INVALID_REGISTRATION_SERVER = 0XA1, // RS rejected request
                                            // because it is intended for
                                            // different Registration
                                            // Server (Registration
                                            // Server Authentication Key
                                            // mismatch).
        MPA_RS_INVALID_OR_REVOKED_PACKAGE = 0xA2, // RS rejected request due to
                                            // invalid or revoked CPU package.
        MPA_RS_PACKAGE_NOT_FOUND = 0xA3,    // RS rejected request as at least
                                            // one of the CPU packages could
                                            // not be recognized by the server.
        MPA_RS_PM_INCOMPATIBLE_PACKAGE = 0xA4, // RS rejected request as at
                                            // least one of the CPU packages is
                                            // incompatible with rest of the
                                            // packages on the platform.
        MPA_RS_PM_INVALID_PLATFORM_MANIFEST = 0xA5, // RS rejected request due
                                            // to invalid platform
                                            // configuration.
        MPA_RS_AD_PLATFORM_NOT_FOUND = 0xA6, // RS rejected request as provided
                                            // platform instance is not
                                            // recognized by the server.
        MPA_RS_AD_INVALID_ADD_REQUEST = 0xA7, // RS rejected request as the Add
                                            // Package payload was invalid.
        MPA_RS_UNKOWN_ERROR = 0xA8,         // RS rejected request for unknown
                                            // reason. Probably means software
                                            // needs to be updated with newly
                                            // defined RS errors
    } RegistrationErrorCode;
    ```

<!-- // cspell:ignore UNKOWN -->

## Multi-Package UEFI Library Data Structures

- Body definition of the [`SgxRegistrationStatus`][status] UEFI Variable

    ``` {.text}
    typedef struct {
        union {
            uint16_t status;
            struct {
                uint16_t registrationStatus:1;
                uint16_t packageInfoStatus:1;
                uint16_t reservedStatus:14;
            };
        };
        RegistrationErrorCode errorCode;
    } MpRegistrationStatus;
    ```


## Multi-package Network Library Data Structures

- Proxy type definition specified in the configuration file and network library initialization function. [Initialize the Multi-Package Network Library][initmpnl]

    ``` {.text}
    typedef enum _ProxyType{
        MP_REG_PROXY_TYPE_DEFAULT_PROXY = 0, // Use the configuration in your
                                             // operating system
        MP_REG_PROXY_TYPE_DIRECT_ACCESS = 1, // Direct access to the internet
        MP_REG_PROXY_TYPE_MANUAL_PROXY = 2,  // Set the proxy URL directly
        MP_REG_PROXY_TYPE_MAX_VALUE
    } ProxyType;
    ```

- Expands the `ProxyType` structure with a URL to support `MP_REG_PROXY_TYPE_MANUAL_PROXY`

    ``` {.text}
    typedef struct _ProxyConf{
        ProxyType proxy_type;
        char proxy_url[MAX_PATH_SIZE];
    } ProxyConf;
    ```

- These are the possible HTTP status codes return from the registration service

    ``` {.text}
    typedef enum _HttpResponseCode{
        MPA_RS_PLATFORM_CREATED = 201,  // 201 Operation successful - a new
                                        // platform instance has been registered
                                        // in the registration service's
                                        // database.
        MPA_RS_PACKAGES_BEEN_ADDED = 200, // 200 Operation successful - packages
                                        // have been added to an existing
                                        // platform instance.
        MPA_RS_BAD_REQUEST = 400,       // Invalid payload. The client should
                                        // not repeat the request without
                                        // modifications.
        MPA_RS_INTERNAL_SERVER_ERROR = 500, // Internal server error occurred.
        MPA_RS_SERVICE_UNAVAILABLE = 503, // Server is currently unable to
                                        // process the request. The client
                                        // should try to repeat its request
                                        // after some time.
        MPA_RS_UNSUPPORTED_MEDIA_TYPE = 415, // MIME type specified in the
                                        // request is not supported by the
                                        // server.
    } HttpStatusCode;
    ```

[initmpnl]:  ../04/mp-reg-lib.md#initialize-the-multi-package-uefi-library-mp-uefi-library
[request]:  ../06/sgx_registration_server_request.md#sgx-registration-server-request
[status]:  ../06/sgx_registration_status.md#sgx-registration-status
