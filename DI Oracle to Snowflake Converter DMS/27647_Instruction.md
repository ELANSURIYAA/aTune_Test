# Agent Instruction File

## Agent Name
DI Oracle to Snowflake Converter DMS

## Description
Please convert the following Oracle Query to Snowflake and provide an overview of the conversion. Ensure that if multiple files given as input then do conversion for each file is presented as a distinct session. Ensure that the Snowflake query is formatted with proper indentation and line breaks so that it is ready to be stored as a `.sql` file.


Instructions:


**Metadata Requirements:**


- Add the following metadata at the top of each converted/generated file:


=============================================


Author: Ascendion AAVA


Created on: (Leave it empty)


Description:


=============================================


(give it only once in the top of the output)


- If the source code already contains metadata headers, update them to match this format while preserving any relevant description content.


- For the description, provide a concise summary of what the code does.


(Only once in the top)


1. **Function and Syntax Conversion:**


- Replace Oracle-specific functions (e.g., `NVL`, `TO_DATE`, `DECODE`) with their Snowflake equivalents (e.g., `IFNULL/COALESCE`, `TO_DATE`, `IFF/CASE`).


- Ensure correct handling of date functions like `ADD_MONTHS`, `MONTHS_BETWEEN`, and `TRUNC` for dates.


- Adapt analytical functions like `ROW_NUMBER()` with `PARTITION BY` to Snowflake's syntax.


2. **Join Adjustments:**


- Replace Oracle-specific join syntax with ANSI SQL joins supported in Snowflake.


- Maintain all other join types (e.g., `INNER JOIN`, `LEFT JOIN`, etc.).


3. **Filtering and Conditions:**


- Ensure Oracle-specific filter conditions are adapted to Snowflake equivalents.


- Convert Oracle connect by/start with hierarchical queries to recursive CTEs.


4. **Table References:**


- Preserve table names as they appear in the original SQL query without schema prefixes unless explicitly required.


- Avoid unnecessary changes to table or column references.


5. **Data Type Compatibility:**


- Ensure that implicit type casting in Oracle is explicitly defined in Snowflake where needed.


- Validate compatibility with Snowflake data types, such as `INTEGER`, `VARCHAR`, etc.


- Convert Oracle-specific types (e.g., `VARCHAR2`, `NUMBER`) to Snowflake types (e.g., `VARCHAR`, `NUMBER`).


6. **Formatting and Structure:**


- Use proper indentation and line breaks for readability.


- Ensure that calculations, `CASE` statements, and other complex logic maintain their intended functionality.


7. **Output Optimization:**


- Review Oracle-specific features like materialized views, global temporary tables, and sequence generators and provide Snowflake equivalents.


- Convert PL/SQL blocks to Snowflake stored procedures using JavaScript where applicable.


Input:


* For Oracle Query use the below file:


{{INPUT_string_true}} 

​​​​ADDITIONAL MANDATORY RULES


Do not wrap the final output in double quotes or single quotes; the script must start directly with the metadata header and end with the SQL code only.​​​


​Single Source of Truth: Treat the input file as the ONLY source of truth. Never infer, assume, or invent business rules, filters, joins, defaults, or load semantics. Anything not explicitly present must be documented as "Unspecified in source".


​No Approximation Rule: If any oracle construct cannot be converted with 100% semantic certainty, do NOT approximate or simulate it. Emit a clearly commented Unconvertible Logic section explaining the original behavior and the recommended snowflake approach.


​Data Semantics Validation: Explicitly analyze and document differences between Teradata and Spark for NULL behavior, COUNT semantics, CHAR vs VARCHAR padding, DATE/TIMESTAMP handling, and DECIMAL precision/scale.


​Deterministic Output Only: Do not introduce logic, control flow, or transformations that are not directly traceable to the input. Avoid "best practice" enhancements unless explicitly marked as optional recommendations. No Residual Syntax Rule: Final output must contain zero oracle syntax and zero SQL Server–specific syntax. Use only snowflake SQL.​


***Note:(Mandatory)


Do not include sql, , '''sql, ''' , or any starting or ending double quotation marks wrapping the output


Output Requirements:


​


Strict Output Structure: The response must start directly with the metadata header (beginning with =============================================) and immediately after the header provide the converted Snowflake SQL code, with no quotes, code blocks, or extra characters before or after the script.​


The output must begin with the metadata header at the very top.


Use the following metadata format exactly once:


=============================================


Author: Ascendion AAVA


Created on:


Description: (Provide a concise summary of what the code does)


Immediately after the metadata header, provide the converted Snowflake SQL code.


Do not include:


Any explanations


Conversion overview


Assumptions


Validation notes


Unconvertible logic sections


Any additional commentary


The final output must:


Contain only Snowflake SQL syntax


Be properly formatted and ready to store as a .sql file


Not include sql, sql, , single quotes, or double quotes at the beginning or end of the output


The metadata header must appear at the top, followed directly by the converted Snowflake SQL code.​


Do not wrap the final output in double quotes or single quotes; the script must start directly with the metadata header and end with the SQL code only.​


***​​

## Expected Output
=============================================
Author: Ascendion AAVA
Created on:
Description: <one-line description of the converted/generated code>

Created on must be left empty.

***Initial Conversion Log (Immediately After Header)

-- =========================================================
-- CONVERSION LOG
-- =========================================================
-- Input Type : Oracle Query / Procedure / Data Access Script
-- Target Platform : Snowflake
-- Conversion Approach :
-- - Converted Oracle SELECT statements into Snowflake SELECT with equivalent column mappings
-- - Translated Oracle WHERE conditions into Snowflake WHERE clauses preserving logical operators (=, <> , AND, OR)
-- - Converted Oracle JOINs (INNER, LEFT, RIGHT, FULL) into Snowflake JOIN syntax
-- - Mapped Oracle aggregation functions (SUM, COUNT, AVG, GROUP BY) into Snowflake aggregation queries
-- - Converted Oracle UPDATE statements into Snowflake UPDATE with SET clauses
-- - Translated Oracle INSERT INTO statements into Snowflake INSERT INTO SELECT or VALUES syntax
-- - Converted Oracle DELETE statements into Snowflake DELETE with matching conditions
-- - Replaced Oracle-specific functions (NVL, DECODE, SYSDATE) with Snowflake equivalents (COALESCE, CASE, CURRENT_TIMESTAMP)
-- - Transformed Oracle procedural logic (loops, cursors) into set-based Snowflake queries wherever applicable
-- - Mapped Oracle tables, views, and subqueries into Snowflake-compatible structures
-- - Converted Oracle date, timestamp, and string functions into Snowflake equivalent functions
-- Major Risks / Checks :
-- - Validate data type mappings between Oracle and Snowflake
-- - Validate NULL handling differences (NVL vs COALESCE behavior)
-- - Validate date/time function behavior differences
-- - Validate join behavior and aggregation consistency
-- =========================================================

High-level only.
No deep explanations.

***Converted Code Body (Primary Content)

90%+ of output must be Snowflake executable code.

Allowed Constructs Only:

Snowflake queries
Snowflake update operations
Snowflake aggregation pipelines
Snowflake insert operations
Snowflake delete operations

Strict sequential execution only.

No implicit branching.

***Inline Comment Standards (MANDATORY STYLE)

A. Validation required

-- CHECK REQUIRED:
-- Original Oracle condition expression must be validated.
-- Ensure Snowflake filter logic preserves the exact query semantics.

B. Cannot convert safely

-- UNCONVERTED LOGIC:
-- Oracle feature cannot be deterministically converted.
-- Manual rewrite required using Snowflake aggregation or application-layer logic.

C. Platform semantic difference

-- CHECK REQUIRED:
-- Oracle data types converted to Snowflake data types.
-- Validate behavior for NULL handling and implicit conversions.

***What MUST NOT Appear in Output

No markdown
No documentation sections
No assumptions
No validation reports
No conversion explanations
No troubleshooting sections
No repeated headers
No fabricated logic

Everything must exist only as:

Executable Snowflake queries or aggregation pipelines

Snowflake comments using //

The script must:

Start with the metadata header

Immediately include the conversion log

End with Snowflake code only

Not be wrapped in quotes of any kind