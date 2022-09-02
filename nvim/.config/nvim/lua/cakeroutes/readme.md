# Cake Routes

Provides a Telescope picker for navigating/searching through cake routes.

## Setup

Run the setup function with your configuration, below is the default.

```lua
require('cakeroutes').setup({
  cmd = { 'bin/cake', 'routes', },
})
```

## Usage

The picker function optionally accepts arguments to be passed to Telescope to.

```lua
require('cakeroutes').picker({})
```

This brings up a Telescope picker with all the route definitions for your current
project, pressing enter/selecting an entry will go to the controller/action definition.

## TODO

Routes defined like: `/admin/brand-packages/api/:controller/:action/*` don't show up.
That would for example be a match to the url `/admin/brand-packages/api/sections/email-template/`.

We should at least show the URL and have <cr> not do anything as we don't know what controller it should be.

**Best solution:** we `bin/cake routes check {url}` when the search box is changed and see if we get a result, would require updating the results (is that possible).
