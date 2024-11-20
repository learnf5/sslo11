The following table maps UCS file Loading and End-State for each SSLO Lab.

|Lab#|Lab Name|UCS Load|UCS End|
|:-----|:-----|:-----|:----|
|1|Confirm Provisioning and Network Configuration|sslo1_base.ucs| N/A |
|2|Import a Signed Certificate|sslo1_base.ucs|sslo1_cert.ucs|
|4|Guided Configuration|sslo1_cert.ucs|sslo1_tf_proxy.ucs|
|4.1|Create a Transparent Forward Proxy| | |
|5|Inspection Services|sslo1_tf_proxy.ucs|sslo1_ef_proxy.ucs|
|5.1|Create an Explicit Forward Proxy| | |
|6|Create a Gateway Reverse Proxy|sslo1_ef_proxy.ucs|sslo1_gw_proxy.ucs|
|6.1|Create a Gateway Reverse Proxy|sslo1_ef_proxy.ucs|sslo1_gw_proxy.ucs|
|6.2|Create an Existing Application|sslo1_gw_proxy.ucs|sslo1_ex_app.ucs|
|7|Identify Components|sslo1_ex_app.ucs|sslo1_id_comp.ucs|
|7.1|Identify Components|sslo1_ex_app.ucs|sslo1_id_comp.ucs|
|7.2|Create Application Reverse Proxy|sslo1_id_comp.ucs|sslo1_in_app.ucs|
|7.3|Enable and Test TLS v1.3|sslo1_in_app.ucs| N/A |
|8|Manage a Security Policy|sslo1_in_app.ucs| N/A |
|8.2|Forward Proxy Authentication|sslo1_in_app.ucs| N/A |
|9|Troubleshooting|sslo1_in_app.ucs|N/A|
|9.2|Deleting and Cleanup of Configurations|sslo1_in_app.ucs|N/A|
|10|SSL Orchestrator High Availability|sslo1_cert.ucs<br/>sslo2_cert.ucs|sslo1_ha.ucs<br/>sslo2_ha.ucs|
