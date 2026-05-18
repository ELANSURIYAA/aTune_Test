=============================================
Author: Ascendion AAVA
Created on:
Description: Stored procedure to orchestrate full refresh load of all bronze layer tables with batch tracking and audit logging
=============================================

-- =========================================================
-- CONVERSION LOG
-- =========================================================
-- Input Type : Oracle Procedure
-- Target Platform : Snowflake
-- Conversion Approach :
-- - Converted Oracle CREATE OR REPLACE PROCEDURE into Snowflake CREATE OR REPLACE PROCEDURE with JavaScript
-- - Translated Oracle variable declarations (VARCHAR2, NUMBER, TIMESTAMP) into Snowflake JavaScript variables
-- - Replaced Oracle SYSTIMESTAMP with Snowflake CURRENT_TIMESTAMP()
-- - Converted Oracle USER function into Snowflake CURRENT_USER()
-- - Replaced Oracle TO_CHAR date formatting with Snowflake TO_VARCHAR and TO_CHAR equivalents
-- - Converted Oracle DBMS_OUTPUT.PUT_LINE into Snowflake JavaScript return statements and logging
-- - Translated Oracle procedure calls into Snowflake CALL statements within JavaScript
-- - Converted Oracle SELECT INTO statements into Snowflake SQL execution with resultSet processing
-- - Replaced Oracle NVL function with Snowflake COALESCE
-- - Converted Oracle EXTRACT function for timestamp arithmetic into Snowflake DATEDIFF
-- - Translated Oracle INSERT INTO statements into Snowflake INSERT with JavaScript SQL execution
-- - Converted Oracle COMMIT into Snowflake auto-commit behavior
-- - Replaced Oracle EXCEPTION WHEN OTHERS with JavaScript try-catch blocks
-- - Converted Oracle SQLERRM and SQLCODE into JavaScript error object properties
-- - Replaced Oracle RAISE_APPLICATION_ERROR with JavaScript throw statement
-- Major Risks / Checks :
-- - Validate timestamp arithmetic conversion from Oracle EXTRACT to Snowflake DATEDIFF
-- - Validate NULL handling differences between Oracle NVL and Snowflake COALESCE
-- - Validate date formatting behavior between Oracle TO_CHAR and Snowflake TO_VARCHAR
-- - Validate transaction handling as Snowflake uses auto-commit by default
-- - Validate error handling behavior between Oracle exceptions and JavaScript try-catch
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
    var v_ErrorMessage = '';
    var v_ErrorNumber = 0;
    var v_ErrorSeverity = 0;
    var v_ErrorState = 0;
    var v_ErrorLine = 0;
    var v_TotalRowsProcessed = 0;
    var v_TotalRowsInserted = 0;
    var v_TotalRowsFailed = 0;
    var v_TablesProcessed = 0;
    var v_TablesSucceeded = 0;
    var v_TablesFailed = 0;
    var v_CurrentUser = '';
    var v_BatchID = '';
    
    try {
        // Get current user
        var userStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_USER()"});
        var userResult = userStmt.execute();
        if (userResult.next()) {
            v_CurrentUser = userResult.getColumnValue(1);
        }
        
        // Get current timestamp and format batch ID
        var timestampStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_TIMESTAMP()"});
        var timestampResult = timestampStmt.execute();
        if (timestampResult.next()) {
            v_StartTime = timestampResult.getColumnValue(1);
        }
        
        var batchStmt = snowflake.createStatement({
            sqlText: "SELECT TO_VARCHAR(:1, 'YYYY-MM-DD HH24:MI:SS.FF3')",
            binds: [v_StartTime]
        });
        var batchResult = batchStmt.execute();
        if (batchResult.next()) {
            v_BatchID = batchResult.getColumnValue(1);
        }
        
        // Log start of overall process
        var logMessage = '';
        logMessage += '================================================================================\n';
        logMessage += 'bronze Layer ETL Pipeline - Started at: ' + v_BatchID + '\n';
        logMessage += 'Executed by: ' + v_CurrentUser + '\n';
        logMessage += 'Batch ID: ' + v_BatchID + '\n';
        logMessage += '================================================================================\n';
        logMessage += '\n';
        
        // Load Table 1: bz_New_Monthly_HC_Report
        var callStmt1 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_New_Monthly_HC_Report(:1)",
            binds: [v_BatchID]
        });
        callStmt1.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 2: bz_SchTask
        var callStmt2 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_SchTask(:1)",
            binds: [v_BatchID]
        });
        callStmt2.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 3: bz_Hiring_Initiator_Project_Info
        var callStmt3 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_Hiring_Initiator_Project_Info(:1)",
            binds: [v_BatchID]
        });
        callStmt3.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 4: bz_Timesheet_New
        var callStmt4 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_Timesheet_New(:1)",
            binds: [v_BatchID]
        });
        callStmt4.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 5: bz_report_392_all
        var callStmt5 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_report_392_all(:1)",
            binds: [v_BatchID]
        });
        callStmt5.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 6: bz_vw_billing_timesheet_daywise_ne
        var callStmt6 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne(:1)",
            binds: [v_BatchID]
        });
        callStmt6.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 7: bz_vw_consultant_timesheet_daywise
        var callStmt7 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_vw_consultant_timesheet_daywise(:1)",
            binds: [v_BatchID]
        });
        callStmt7.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 8: bz_DimDate
        var callStmt8 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_DimDate(:1)",
            binds: [v_BatchID]
        });
        callStmt8.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 9: bz_holidays_Mexico
        var callStmt9 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_holidays_Mexico(:1)",
            binds: [v_BatchID]
        });
        callStmt9.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 10: bz_holidays_Canada
        var callStmt10 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_holidays_Canada(:1)",
            binds: [v_BatchID]
        });
        callStmt10.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 11: bz_holidays
        var callStmt11 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_holidays(:1)",
            binds: [v_BatchID]
        });
        callStmt11.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 12: bz_holidays_India
        var callStmt12 = snowflake.createStatement({
            sqlText: "CALL bronze.usp_Load_bz_holidays_India(:1)",
            binds: [v_BatchID]
        });
        callStmt12.execute();
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Calculate summary statistics from audit log
        var successStmt = snowflake.createStatement({
            sqlText: `SELECT 
                        COUNT(*),
                        COALESCE(SUM(records_inserted), 0)
                      FROM bronze.bz_Audit_Log
                      WHERE batch_id = :1
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
                      WHERE batch_id = :1
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
        var endTimeStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_TIMESTAMP()"});
        var endTimeResult = endTimeStmt.execute();
        if (endTimeResult.next()) {
            v_EndTime = endTimeResult.getColumnValue(1);
        }
        
        var execTimeStmt = snowflake.createStatement({
            sqlText: "SELECT DATEDIFF(SECOND, :1, :2)",
            binds: [v_StartTime, v_EndTime]
        });
        var execTimeResult = execTimeStmt.execute();
        if (execTimeResult.next()) {
            v_ExecutionTime = execTimeResult.getColumnValue(1);
        }
        
        // Log completion
        logMessage += '\n';
        logMessage += '================================================================================\n';
        logMessage += 'bronze Layer ETL Pipeline - Completed Successfully\n';
        logMessage += '================================================================================\n';
        logMessage += 'End Time: ' + v_EndTime + '\n';
        logMessage += 'Execution Time: ' + v_ExecutionTime + ' seconds\n';
        logMessage += 'Tables Processed: ' + v_TablesProcessed + '\n';
        logMessage += 'Tables Succeeded: ' + v_TablesSucceeded + '\n';
        logMessage += 'Tables Failed: ' + v_TablesFailed + '\n';
        logMessage += 'Total Rows Inserted: ' + v_TotalRowsInserted + '\n';
        logMessage += 'Total Rows Failed: ' + (v_TotalRowsFailed || 0) + '\n';
        logMessage += '================================================================================\n';
        
        // Insert master audit record
        var insertAuditStmt = snowflake.createStatement({
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
                        :1,
                        :2,
                        :3,
                        :4,
                        :5,
                        :6,
                        :7,
                        :8,
                        :9,
                        :10,
                        'FULL_REFRESH_ALL_TABLES',
                        CURRENT_TIMESTAMP()
                    )`,
            binds: [v_StartTime, v_StartTime, v_EndTime, v_CurrentUser, v_ExecutionTime, 
                    v_OverallStatus, v_TotalRowsProcessed, v_TotalRowsInserted, 
                    v_TotalRowsFailed, v_BatchID]
        });
        insertAuditStmt.execute();
        
        return logMessage + 'SUCCESS: bronze Layer ETL Pipeline completed successfully.';
        
    } catch (err) {
        // Capture error details
        v_ErrorMessage = err.message;
        v_ErrorNumber = err.code || 0;
        v_ErrorSeverity = 0;
        v_ErrorState = 0;
        v_ErrorLine = err.lineNumber || 0;
        
        // Get end time
        var endTimeStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_TIMESTAMP()"});
        var endTimeResult = endTimeStmt.execute();
        if (endTimeResult.next()) {
            v_EndTime = endTimeResult.getColumnValue(1);
        }
        
        // Calculate execution time
        var execTimeStmt = snowflake.createStatement({
            sqlText: "SELECT DATEDIFF(SECOND, :1, :2)",
            binds: [v_StartTime, v_EndTime]
        });
        var execTimeResult = execTimeStmt.execute();
        if (execTimeResult.next()) {
            v_ExecutionTime = execTimeResult.getColumnValue(1);
        }
        
        v_OverallStatus = 'FAILED';
        
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
        var insertErrorStmt = snowflake.createStatement({
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
                        :1,
                        :2,
                        :3,
                        :4,
                        :5,
                        :6,
                        :7,
                        :8,
                        'FULL_REFRESH_ALL_TABLES',
                        CURRENT_TIMESTAMP()
                    )`,
            binds: [v_StartTime, v_StartTime, v_EndTime, v_CurrentUser, v_ExecutionTime, 
                    v_OverallStatus, 'Error ' + v_ErrorNumber + ': ' + v_ErrorMessage, v_BatchID]
        });
        insertErrorStmt.execute();
        
        // Throw error
        throw errorLog + 'FAILED: ' + v_ErrorMessage;
    }
$$;
