> [!NOTE]
> The items here are not guaranteed to be worked on. Sapling is in early
> development and may have issues, this is not production grade software.

- [x] In memory timeline cache
- [ ] current user info in the sidebar
- [ ] post visibility insights on post view
- [ ] Communities
  - [ ] Community domains
    - [x] Each community can have it's own subdomain, allowing users to own their social presense
    - [x] Communities can have custom domains offering a greater level of control
    - [ ] User accounts are scoped to subdomain/domain
    - [ ] Users can sign up on subdomain/domain and have their primary community set
    - [ ] Community white labeling
  - [ ] Community interactions
    - [x] Posts can be scoped to communities
    - [x] Post visibility options
    - [x] Users can view community timelines
    - [x] Create communities
    - [x] List communities
    - [ ] Community white labeling
    - [ ] Community federation
  - [ ] Community memberships
    - [x] Primary community (accounts belong to one community)
    - [x] Community memberships (accounts belong to one community)
    - [x] Post visibility options
    - [x] Community members can post private community posts
    - [x] Non-members see a public posts only version of the community timeline
    - [x] Join communities
    - [ ] Leave communities
  - [ ] Community administration
    - [ ] Invite members
    - [ ] Kick members
    - [ ] Invite existing sapling users
- [x] Posts
  - [x] Create, edit, & delete
  - [x] Attach pictures posts
  - [x] Attach videos to posts
  - [x] Reply to posts
  - [x] Favorite posts
  - [ ] Attach polls
- [ ] Mastodon Importer (local only)
  - [x] Import users
  - [x] Import posts
  - [x] Import accounts
  - [x] Import favorites
  - [ ] Import polls
- [ ] Events
  - [ ] Create Events
  - [ ] Invite users
  - [ ] RSVP to events
- [ ] Notifications
- [ ] Progressive web app
- [ ] Wishlists
- [ ] Secret Santa
- [ ] ActivityPub federation
- [ ] Color coordination of communities

### Issues

- comments layout is fucked up at the moment
- timeline caches need to be invalidated after a user joins a community
- some associations are on user when they should be on account
