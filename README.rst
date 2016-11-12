================
mattermost-formula
================

This sets up Mattermost, an open source alternative to Slack.

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================


``mattermost``
------------

Installs the mattermost archive, and starts the associated mattermost service.


``mattermost.uninstall``
------------------

Uninstalls the mattermost archive, and removes the associated mattermost service.


``mattermost.nginx``
------------------

Installs nginx as a proxy to mattermost.


``mattermost.nginx_ssl``
------------------

If you're fine with a self-signed tls certi for nginx, use this state.


``mattermost.postgresql``
------------------

Installs a local postgresql instance and sets up the db and user.