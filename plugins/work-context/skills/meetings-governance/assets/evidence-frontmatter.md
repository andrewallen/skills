# Evidence companion frontmatter

Include only identifiers that actually exist; never write `unknown` as an ID. For local files use `source_file` and a hash when available, and `source_document_id` only for a real stable document identity. Single-quote Windows paths. Record `sensitivity` only from a platform-applied classification label, exactly as exposed; do not infer or interpret classification from source-content markings.

Each newly created companion uses the matching `document_role` and `template`
identifier below, plus `created_by` and `last_governed_by` set to
`meetings-governance@<CURRENT_SKILL_VERSION>`. These are schemas for new
companions, not instructions to retrofit existing files. Preserve source
bodies faithfully; put this metadata outside the copied source text.

## Transcript

```yaml
document_role: meeting-transcript-companion
template: meeting-transcript-companion@1.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
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
sensitivity_source:
retrieved_at:
```

## Chat

```yaml
document_role: meeting-chat-companion
template: meeting-chat-companion@1.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
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
sensitivity:
sensitivity_source:
retrieved_at:
captured_at:
```

## Email

```yaml
document_role: meeting-email-companion
template: meeting-email-companion@1.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
meeting_id:
source_type: Outlook-email
email_id:
conversation_id:
sent_at:
from:
to: []
source_document_id:
source_file:
source_hash:
sensitivity:
sensitivity_source:
retrieved_at:
```

## Follow-up Email

```yaml
document_role: meeting-follow-up-email-companion
template: meeting-follow-up-email-companion@1.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
meeting_id:
source_type: Outlook-email
email_id:
conversation_id:
sent_at:
from:
to: []
meeting_link_basis:
source_document_id:
source_file:
source_hash:
sensitivity:
sensitivity_source:
retrieved_at:
```

## Follow-up Chat

```yaml
document_role: meeting-follow-up-chat-companion
template: meeting-follow-up-chat-companion@1.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
meeting_id:
source_type: Teams-chat
chat_id:
message_ids: []
occurrence_window:
meeting_link_basis:
sender:
created_at:
modified_at:
sensitivity:
sensitivity_source:
retrieved_at:
```

## Recap

```yaml
document_role: meeting-recap-companion
template: meeting-recap-companion@1.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
meeting_id:
source_type:
source_document_id:
source_file:
source_hash:
author:
created_at:
modified_at:
sensitivity:
sensitivity_source:
retrieved_at:
```

## Notes

```yaml
document_role: meeting-notes-companion
template: meeting-notes-companion@1.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
meeting_id:
source_type:
source_document_id:
source_file:
source_hash:
author:
created_at:
modified_at:
sensitivity:
sensitivity_source:
retrieved_at:
```

## Attendance

```yaml
document_role: meeting-attendance-companion
template: meeting-attendance-companion@1.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
meeting_id:
source_type: attendance-report
attendance_report_id:
call_id:
source_document_id:
source_file:
source_hash:
participants: []
sensitivity:
sensitivity_source:
retrieved_at:
```

## Recording

```yaml
document_role: meeting-recording-companion
template: meeting-recording-companion@1.0
created_by: meetings-governance@<CURRENT_SKILL_VERSION>
last_governed_by: meetings-governance@<CURRENT_SKILL_VERSION>
meeting_id:
source_type:
media_class:
recording_id:
call_id:
source_file:
source_hash:
source_url:
duration:
sensitivity:
sensitivity_source:
retrieved_at:
```
