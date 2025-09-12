module audit_logger (
    input event_trigger,
    input [127:0] user_did,
    input [255:0] event_data,
    input [255:0] resource_id,
    output reg [511:0] audit_hash,
    output reg [63:0] audit_timestamp
       );
always @(posedge event_trigger) begin
        audit_timestamp <= $time;
        audit_hash <= sha3_512({user_did, event_data, resource_id, audit_timestamp});
        // log function writes to managed, permissioned append-only federal archive
        log_event(audit_hash, audit_timestamp, user_did, event_data, resource_id);
    end
endmodule
