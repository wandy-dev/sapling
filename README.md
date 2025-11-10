> [!NOTE]
> This document is not complete as I haven't gathered all my thoughts, and the
> software is in early development, meaning details are likely to be added
> or changed

# 🌱 Sapling

![Screen shot of the Sapling hompage](https://github.com/user-attachments/assets/24141097-bd33-4306-b1dc-01920bcc620a)
Sapling is an early development experiment in building social apps
for small groups. Intended to be self-hosted for a group of people that all
share a common connection point, whether that be a family, friend group, a
business, or a town.

For a given deployment of sapling, there isn't a
tradition concept of relationships between users like followers or friends. Your
users should all have a common interest so everyone follows everyone by default
on a "Community" timeline.

There is a possibility of adding [ActivityPub](https://www.w3.org/TR/activitypub/)
federation to allow members of separate instances of Sapling to follow each
other in a "Global" timeline

## Motivation
I host a [Mastodon](https://github.com/mastodon/mastodon) instance for my family, and there are some pain points that I
hope Sapling will be able to address.

### Timeline
Aside from everyone following everyone by default being much easier for my
use case, the microblogging format doesn't really work well for smaller groups.
Having replies in the timeline at the same level of original posts is not a
great experience. On a small social platform you want your timeline to be full
of the meat, not the potatos.

### Philosophy
Mastodon has had [#861 Add a "Local timeline" privacy option]() open since April 2017.
Mastodon's creator is strongly opposed to the feature as in his words it
has a ["Centeralizing Force"](https://github.com/mastodon/mastodon/issues/861#issuecomment-1135022537)
They are in favor of using the upcoming support of groups, which can be public
or private, to support this feature without hard coding it in the software.

In my mind, yeah fair point... but that's fine. My instance is for my family,
of course our discussions should be centralized. In other cases it could be a
school, a company, or just an instance owner telling their users (and not the
whole world) that the site will be down for maintenance.

In my mind, building software that is targeted at admins running smaller
instances will have a greater effect in reducing centralization.

### "Marketing"
Section Incomplete

## Features
A lot of these are far off, if ever, ideas. No guarantee they will be
implemented.
- [x] Create posts
- [x] Attach pictures and view to posts
- [x] Attach videos to posts
- [x] Reply to posts
- [x] Favorite posts
- [x] Community timeline of posts from all users in reverse chronological order
- [x] View videos on posts
- [ ] Import from Mastodon
- [ ] Progressive web app
- [ ] Create Events
- [ ] RSVP to events
- [ ] Polls
- [ ] Wishlists
- [ ] Federated "Global" Timeline
- [ ] Follow remote users
- [ ] Multitenancy
- [ ] Cross post to other platforms
- [ ] In memory timeline cache

### Tech stack
- [Ruby on Rails](https://rubyonrails.org/) and [hotwire](https://hotwired.dev/) for web-application stack, and perhaps one day native apps
- [Bulma](https://bulma.io/) for styling
- [RSpec](https://rspec.info/) and [Capybara](https://teamcapybara.github.io/capybara/) for the test suite

### Requirements
- Ruby 3.3.6
- [vips](https://www.libvips.org/) for processing images
