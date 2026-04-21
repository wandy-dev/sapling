> [!NOTE]
> This document is not complete as I haven't gathered all my thoughts, and the
> software is in early development, meaning details are likely to be added
> or changed

# 🌱 Sapling

![Screen shot of the Sapling hompage](https://github.com/user-attachments/assets/24141097-bd33-4306-b1dc-01920bcc620a)
Sapling is an early development experiment in building social apps
for small groups. Intended provide a way for a group of people that all
share a common connection point, whether that be a family, friend group, a
business, or a town, to own their online presense, without the headache of
hosting an application.

It is also intended for people with hosting skills to provide these spaces to
non-technical users by hosting one application. Long term goals include domain
reselling and providing infrastructure for payment to the application host.

For a given deployment of sapling, there isn't a
tradition concept of relationships between users like followers or friends. Your
users should all have a common interest so everyone follows everyone in their
"Community" by default on a shared timeline.

There is a possibility of adding [ActivityPub](https://www.w3.org/TR/activitypub/)
federation though this is not the focus at this time.

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
Mastodon has had [#861 Add a "Local timeline" privacy option](https://github.com/mastodon/mastodon/issues/861)
open since April 2017.
Mastodon's creator is strongly opposed to the feature as in his words it
has a ["Centeralizing Force"](https://github.com/mastodon/mastodon/issues/861#issuecomment-1135022537)
They are in favor of using the upcoming support of groups, which can be public
or private, to support this feature without hard coding it in the software.

In my mind, yeah fair point... but that's fine. My instance is for my family,
of course our discussions should be centralized. In other cases it could be a
school, a company, or just an instance owner telling their users (and not the
whole world) that the site will be down for maintenance.

There's also the issue of other groups I'd like to socialize with. My friends
wouldn't fit well into my family instance, so I would have to host another
instance for them, and my SO's friends, and their friends, etc, etc...

But don't communities function as groups? Well yes and no. While communities are
similar to groups on other platforms, the big differentiator here is that
communities on sapling can have their own subdomain or domain name. The end goal
is to have each community behave as it's own instance, while living under the
same application as other instances. "Federating" with other local instances
without ActivityPub, and remote instance with ActivityPub.

This again is a centralizing force, but it is a trade off that I've decided is
worth it for me as it provides people without a technical background the ability
to create their own space on the open social web, something that can't really
be done today with existing ActivityPub apps.

### "Marketing"
Section Incomplete

## Features
Below are a list of implemented features, there is a [roadmap](ROADMAP.md) with
additional features, but they are not guaranteed to be worked on.

- In memory timeline cache
- Communities
  - Community domains
    - Each community can have it's own subdomain, allowing users to own their social presense
    - Communities can have custom domains offering a greater level of control
  - Community interactions
    - Posts can be scoped to communities
    - Post visibility options
    - Users can view community timelines
    - Community members can post private community posts
    - Non-members see a public posts only version of the community timeline
  - Community memberships
    - Primary community (accounts belong to one community)
    - Community memberships (accounts belong to one community)
- Posts
  - Create, edit & delete
  - Attach pictures posts
  - Attach videos to posts
  - Reply to posts
  - Favorite posts
- Mastodon Importer (local only)
  - Import users
  - Import posts
  - Import accounts
  - Import favorites

### Tech stack
- [Ruby on Rails](https://rubyonrails.org/) and [hotwire](https://hotwired.dev/) for web-application stack, and perhaps one day native apps
- [Bulma](https://bulma.io/) for styling
- [RSpec](https://rspec.info/) and [Capybara](https://teamcapybara.github.io/capybara/) for the test suite

### Requirements
- Ruby 3.3.6
- [vips](https://www.libvips.org/) for processing images
- [Redis](https://redis.io/) for timeline caching
