=============================================
Author: Ascendion AAVA
Created on:
Description: Stored procedure to orchestrate full refresh load of all bronze layer tables with audit logging and error handling
=============================================

-- =========================================================
-- CONVERSION LOG
-- =========================================================
-- Input Type : Oracle Procedure
-- Target Platform : Snowflake
-- Conversion Approach :
-- - Converted Oracle CREATE OR REPLACE PROCEDURE into Snowflake CREATE OR REPLACE PROCEDURE with JavaScript
-- - Replaced Oracle variable declarations (VARCHAR2, NUMBER, TIMESTAMP) with Snowflake JavaScript equivalents
-- - Converted SYSTIMESTAMP to CURRENT_TIMESTAMP()
-- - Replaced USER with CURRENT_USER()
-- - Converted TO_CHAR date formatting to TO_VARCHAR with Snowflake date format patterns
-- - Replaced DBMS_OUTPUT.PUT_LINE with JavaScript console logging and result set returns
-- - Converted Oracle procedure calls into Snowflake CALL statements using snowflake.execute
-- - Replaced Oracle SELECT INTO with Snowflake result set processing
-- - Converted NVL to COALESCE
-- - Replaced EXTRACT with DATEDIFF for time calculations
-- - Converted Oracle INSERT INTO with Snowflake INSERT INTO using snowflake.execute
-- - Replaced COMMIT with Snowflake auto-commit behavior
-- - Converted Oracle EXCEPTION WHEN OTHERS with JavaScript try-catch blocks
-- - Replaced SQLERRM and SQLCODE with JavaScript error object properties
-- - Converted RAISE_APPLICATION_ERROR to JavaScript throw statement
-- Major Risks / Checks :
-- - Validate TIMESTAMP precision and format differences between Oracle and Snowflake
-- - Validate NULL handling with COALESCE vs NVL
-- - Validate date arithmetic and DATEDIFF behavior
-- - Validate transaction handling (Oracle explicit COMMIT vs Snowflake auto-commit)
-- - Validate error handling and exception propagation
-- =========================================================

CREATE OR REPLACE PROCEDURE bronze.usp_Load_bronze_Layer_Full()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
    // Variable declarations
    var v_ProcedureName = 'bronze.usp_Load_bronze_Layer_Full';
    var v_StartTime = new Date();
    var v_EndTime;
    var v_ExecutionTime;
    var v_OverallStatus = 'SUCCESS';
    var v_ErrorMessage;
    var v_ErrorNumber;
    var v_ErrorSeverity;
    var v_ErrorState;
    var v_ErrorLine;
    var v_TotalRowsProcessed = 0;
    var v_TotalRowsInserted = 0;
    var v_TotalRowsFailed = 0;
    var v_TablesProcessed = 0;
    var v_TablesSucceeded = 0;
    var v_TablesFailed = 0;
    var v_CurrentUser;
    var v_BatchID;
    
    try {
        // Get current user
        var userStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_USER()"});
        var userResult = userStmt.execute();
        userResult.next();
        v_CurrentUser = userResult.getColumnValue(1);
        
        // Get current timestamp and format batch ID
        var timestampStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_TIMESTAMP()"});
        var timestampResult = timestampStmt.execute();
        timestampResult.next();
        var currentTimestamp = timestampResult.getColumnValue(1);
        
        var batchIdStmt = snowflake.createStatement({
            sqlText: "SELECT TO_VARCHAR(?, 'YYYY-MM-DD HH24:MI:SS.FF3')",
            binds: [currentTimestamp]
        });
        var batchIdResult = batchIdStmt.execute();
        batchIdResult.next();
        v_BatchID = batchIdResult.getColumnValue(1);
        
        // Log start of overall process
        var logMessage = '';
        logMessage += '================================================================================\n';
        logMessage += 'bronze Layer ETL Pipeline - Started at: ' + v_BatchID + '\n';
        logMessage += 'Executed by: ' + v_CurrentUser + '\n';
        logMessage += 'Batch ID: ' + v_BatchID + '\n';
        logMessage += '================================================================================\n';
        logMessage += '\n';
        
        // Load Table 1: bz_New_Monthly_HC_Report
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_New_Monthly_HC_Report(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 2: bz_SchTask (excludes TIMESTAMP column)
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_SchTask(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 3: bz_Hiring_Initiator_Project_Info
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_Hiring_Initiator_Project_Info(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 4: bz_Timesheet_New
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_Timesheet_New(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 5: bz_report_392_all
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_report_392_all(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 6: bz_vw_billing_timesheet_daywise_ne
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 7: bz_vw_consultant_timesheet_daywise
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_vw_consultant_timesheet_daywise(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 8: bz_DimDate
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_DimDate(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 9: bz_holidays_Mexico
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays_Mexico(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 10: bz_holidays_Canada
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays_Canada(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 11: bz_holidays
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 12: bz_holidays_India
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays_India(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Calculate summary statistics from audit log
        var successStmt = snowflake.createStatement({
            sqlText: `SELECT 
                        COUNT(*),
                        COALESCE(SUM(records_inserted), 0)
                      FROM bronze.bz_Audit_Log
                      WHERE batch_id = ?
                        AND status = 'SUCCESS'`,
            binds: [v_BatchID]
        });
        var successResult = successStmt.execute();
        if (successResult.next()) {
            v_TablesSucceeded = successResult.getColumnValue(1);
            v_TotalRowsInserted = successResult.getColumnValue(2);
        }
        
        var failedStmt = snowflake.createStatement({
            sqlText: `SELECT 
                        COUNT(*),
                        COALESCE(SUM(records_failed), 0)
                      FROM bronze.bz_Audit_Log
                      WHERE batch_id = ?
                        AND status = 'FAILED'`,
            binds: [v_BatchID]
        });
        var failedResult = failedStmt.execute();
        if (failedResult.next()) {
            v_TablesFailed = failedResult.getColumnValue(1);
            v_TotalRowsFailed = failedResult.getColumnValue(2);
        }
        
        v_TotalRowsProcessed = v_TotalRowsInserted + (v_TotalRowsFailed || 0);
        
        // Calculate execution time
        v_EndTime = new Date();
        v_ExecutionTime = (v_EndTime - v_StartTime) / 1000;
        
        // Get formatted end time
        var endTimeStmt = snowflake.createStatement({
            sqlText: "SELECT TO_VARCHAR(CURRENT_TIMESTAMP(), 'YYYY-MM-DD HH24:MI:SS.FF3')"
        });
        var endTimeResult = endTimeStmt.execute();
        endTimeResult.next();
        var formattedEndTime = endTimeResult.getColumnValue(1);
        
        // Log completion
        logMessage += '\n';
        logMessage += '================================================================================\n';
        logMessage += 'bronze Layer ETL Pipeline - Completed Successfully\n';
        logMessage += '================================================================================\n';
        logMessage += 'End Time: ' + formattedEndTime + '\n';
        logMessage += 'Execution Time: ' + v_ExecutionTime + ' seconds\n';
        logMessage += 'Tables Processed: ' + v_TablesProcessed + '\n';
        logMessage += 'Tables Succeeded: ' + v_TablesSucceeded + '\n';
        logMessage += 'Tables Failed: ' + v_TablesFailed + '\n';
        logMessage += 'Total Rows Inserted: ' + v_TotalRowsInserted + '\n';
        logMessage += 'Total Rows Failed: ' + (v_TotalRowsFailed || 0) + '\n';
        logMessage += '================================================================================\n';
        
        // Insert master audit record
        var auditStmt = snowflake.createStatement({
            sqlText: `INSERT INTO bronze.bz_Audit_Log (
                        source_table,
                        target_table,
                        load_timestamp,
                        start_timestamp,
                        end_timestamp,
                        processed_by,
                        processing_time,
                        status,
                        records_processed,
                        records_inserted,
                        records_failed,
                        batch_id,
                        load_type,
                        created_date
                    )
                    VALUES (
                        'source_layer.*',
                        'bronze.*',
                        ?,
                        ?,
                        CURRENT_TIMESTAMP(),
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        'FULL_REFRESH_ALL_TABLES',
                        CURRENT_TIMESTAMP()
                    )`,
            binds: [
                currentTimestamp,
                currentTimestamp,
                v_CurrentUser,
                v_ExecutionTime,
                v_OverallStatus,
                v_TotalRowsProcessed,
                v_TotalRowsInserted,
                v_TotalRowsFailed,
                v_BatchID
            ]
        });
        auditStmt.execute();
        
        return logMessage + 'SUCCESS';
        
    } catch (err) {
        // Capture error details
        v_ErrorMessage = err.message;
        v_ErrorNumber = err.code || 0;
        v_ErrorSeverity = 0;
        v_ErrorState = 0;
        v_ErrorLine = err.lineNumber || 0;
        
        v_EndTime = new Date();
        v_ExecutionTime = (v_EndTime - v_StartTime) / 1000;
        v_OverallStatus = 'FAILED';
        
        // Get formatted end time
        var endTimeStmt = snowflake.createStatement({
            sqlText: "SELECT TO_VARCHAR(CURRENT_TIMESTAMP(), 'YYYY-MM-DD HH24:MI:SS.FF3')"
        });
        var endTimeResult = endTimeStmt.execute();
        endTimeResult.next();
        var formattedEndTime = endTimeResult.getColumnValue(1);
        
        // Get current timestamp for error logging
        var errorTimestampStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_TIMESTAMP()"});
        var errorTimestampResult = errorTimestampStmt.execute();
        errorTimestampResult.next();
        var errorCurrentTimestamp = errorTimestampResult.getColumnValue(1);
        
        // Log error
        var errorLog = '';
        errorLog += '\n';
        errorLog += '================================================================================\n';
        errorLog += 'ERROR in bronze Layer ETL Pipeline\n';
        errorLog += '================================================================================\n';
        errorLog += 'Error Number: ' + v_ErrorNumber + '\n';
        errorLog += 'Error Severity: ' + v_ErrorSeverity + '\n';
        errorLog += 'Error State: ' + v_ErrorState + '\n';
        errorLog += 'Error Line: ' + v_ErrorLine + '\n';
        errorLog += 'Error Message: ' + v_ErrorMessage + '\n';
        errorLog += '================================================================================\n';
        
        // Insert error audit record
        var errorAuditStmt = snowflake.createStatement({
            sqlText: `INSERT INTO bronze.bz_Audit_Log (
                        source_table,
                        target_table,
                        load_timestamp,
                        start_timestamp,
                        end_timestamp,
                        processed_by,
                        processing_time,
                        status,
                        error_message,
                        batch_id,
                        load_type,
                        created_date
                    )
                    VALUES (
                        'source_layer.*',
                        'bronze.*',
                        ?,
                        ?,
                        CURRENT_TIMESTAMP(),
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        'FULL_REFRESH_ALL_TABLES',
                        CURRENT_TIMESTAMP()
                    )`,
            binds: [
                errorCurrentTimestamp,
                errorCurrentTimestamp,
                v_CurrentUser,
                v_ExecutionTime,
                v_OverallStatus,
                'Error ' + v_ErrorNumber + ': ' + v_ErrorMessage,
                v_BatchID
            ]
        });
        errorAuditStmt.execute();
        
        // Re-throw error
        throw errorLog + v_ErrorMessage;
    }
$$;