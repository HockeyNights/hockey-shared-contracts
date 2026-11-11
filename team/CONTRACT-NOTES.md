# HOCBACK-37: Team completion contracts

Branch is based on the pending HOCBACK-31 contract branch, which already contains
HOCBACK-30 pagination/expiry fields. Those PRs must be reconciled before merging;
this task does not replace their implementations.

New routes cover personal invites, decline/revoke/resend, club profile and staff
contacts. Create supports an initial player/coach list (both invited until accepted),
short description/logo and optional club linkage. Nullable PATCH fields can be
cleared explicitly with `clearFields`; omitted fields stay unchanged. Club staff
have a server ID and an optional account UUID; contacts do not grant permissions.

`GetTeamClubProfile` returns `{club: ...}` (no club: unset/null), not the raw MSW
object. Lists use envelopes and pagination; frontend needs a transport adapter.
Internal access methods and account/profile batches have no HTTP routes.
Team access requests must be authenticated as a service, not trusted from a user body.
Known action names are documented by the Team implementation; unknown actions deny.

Contracts describe the intended completed slice. Do not publish the new routes as
ready until the corresponding Team/Training handlers pass end-to-end tests.

Notification already accepts a UUID idempotency key and template variables.
No Mail or Notification protocol change is needed for Team templates.

Generation uses pinned official protovalidate source in the compiler image.
Local native generation uses the same commit as an additional protoc include.
