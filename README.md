# box-ngrok
[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors)

### Ngrok integration with CommandBox

Ngrok is a service that will proxy a locally-running server to the Internet where any coworker, friend, or client with a browser 
can view the local site site you have running.  Use this to demo a new site or ask a friend to look at an error for you.  This is also great for testing integration with 3rd party systems (like Stripe webhooks) while still developing on localhost!

## Usage
Use the commands that come with this module to start and stop Ngrok shares.
### Start a share
```bash
server share start
# or
share
```

It will:

1. Start the CommandBox server if it is not already running.
2. Start Ngrok using the embedded binaries for your platform.
3. Stop any currently open Ngrok tunnels (since the free version only allows one at a time).
4. Create the new Ngrok tunnel.
5. Display the share url.
6. Open the share url in the browser.

### Stop a share
```bash
server share stop
```

If you stop a server that is being shared, the Ngrok tunnel will be closed for you.




## Contributors

Thanks goes to these wonderful people ([emoji key](https://github.com/kentcdodds/all-contributors#emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
| [<img src="https://avatars2.githubusercontent.com/u/2583646?v=3" width="100px;"/><br /><sub>Eric Peterson</sub>](https://github.com/elpete)<br />[🐛](https://github.com/elpete/box-ngrok/issues?q=author%3Aelpete) [💻](https://github.com/elpete/box-ngrok/commits?author=elpete) | [<img src="https://avatars3.githubusercontent.com/u/584009?v=3" width="100px;"/><br /><sub>Brad Wood</sub>](http://www.codersrevolution.com)<br />💬 📝 [💻](https://github.com/elpete/box-ngrok/commits?author=bdw429s) 👀 📢 |
| :---: | :---: |
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/kentcdodds/all-contributors) specification. Contributions of any kind welcome!