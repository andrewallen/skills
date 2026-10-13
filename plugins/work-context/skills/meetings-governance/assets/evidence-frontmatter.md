# Evidence companion frontmatter

Include only identifiers that actually exist; never write `unknown` as an ID. For local files use `source_file` and a hash when available, and `source_document_id` only for a real stable document identity. Single-quote Windows paths.

## Transcript

```yaml
meeting_id:
source_type:
transcript_id:
call_id:
source_document_id:
source_file:
source_hash:
source_object_count:
source_part:
total_segments:
retrieved_segments:
time_bounds:
pagination_complete:
overlap_disposition:
speaker_attribution:
timestamps_available:
sensitivity:
retrieved_at:
```

## Chat

```yaml
meeting_id:
source_type: Teams-meeting-chat
chat_id:
occurrence_window:
source_total_records:
captured_non_system_messages:
captured_lifecycle_events:
latest_created_at:
latest_modified_at:
pagination_complete:
captured_at:
```
