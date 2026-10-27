# Known tool behaviour

Observed limits and quirks of tools commonly used with Meetings Governance, as of 2026-10-27. Tools change; check the installed schema, and prefer what it says over this note. The rules in [capture.md](capture.md) do not depend on any of these facts being current.

| Tool or route | Observation | Consequence |
| --- | --- | --- |
| WorkIQ `fetch_blob` | Limits the raw file to 4 MB and returns base64, for email attachments as well as drive files. Range headers are not supported. | Send larger originals straight to an original-file route; do not retry inline. |
| WorkIQ item reads | A narrowed field selection can omit the download-URL fields. | Read the item record without the selection when a download URL is needed. |
| Other inline-base64 Microsoft 365 tools | Some document caps around 5 MB; some return only metadata or indexed text. | Read each schema; a search or metadata tool is not a downloader. |
| Mail attachment-download tools | Returned a complete 8.5 MB attachment that WorkIQ refused. The reported `size` differed from the decoded length by under 0.01%. | Prefer them for large attachments; accept a small size difference only for a structurally intact file. |
| Host output files | Oversized tool results are saved to a file. The serialiser escaped `+` as `+` inside base64. | Parse the file as JSON before decoding; never extract base64 by pattern. |
| Drive download URLs from metadata tools | Not always pre-authenticated: a plain request received `401`, and a general CLI token without file scope received `403`. | Treat as route failures and move to the next route. |
| Signed-in default browser | Opening the returned URL from the shell saved a complete 16.9 MB file matching size, zip integrity and provider hash (one Windows and Edge environment). | Route 4 works when routes 1 to 3 do not. |
