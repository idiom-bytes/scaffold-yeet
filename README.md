# 🏗 Scaffold-Yeet 🏗

<div align="center">
  <img src="https://github.com/user-attachments/assets/1eb04f3d-88a3-4105-b6da-10b3a1f848fe" alt="scaffold-yeet" width="300"/>
</div>

<h4 align="center">
  <a href="https://docs.scaffoldeth.io">Documentation</a> |
  <a href="https://scaffoldeth.io">Website</a>
</h4>

🧪 A fork of Scaffold-Eth-2 to yeet with. An open-source, up-to-date toolkit for building decentralized applications (dapps) on the Ethereum blockchain. It's designed to make it easier for developers to create and deploy smart contracts and build user interfaces that interact with those contracts.

⚙️ Built using NextJS, RainbowKit, Foundry/Hardhat, Wagmi, Viem, and Typescript.

- ✅ **Contract Hot Reload**: Your frontend auto-adapts to your smart contract as you edit it.
- 🪝 **[Custom hooks](https://docs.scaffoldeth.io/hooks/)**: Collection of React hooks wrapper around [wagmi](https://wagmi.sh/) to simplify interactions with smart contracts with typescript autocompletion.
- 🧱 [**Components**](https://docs.scaffoldeth.io/components/): Collection of common web3 components to quickly build your frontend.
- 🔥 **Burner Wallet & Local Faucet**: Quickly test your application with a burner wallet and local faucet.
- 🔐 **Integration with Wallet Providers**: Connect to different wallet providers and interact with the Ethereum network.

![Debug Contracts tab](https://github.com/scaffold-eth/scaffold-eth-2/assets/55535804/b237af0c-5027-4849-a5c1-2e31495cccb1)

## Requirements

Before you begin, you need to install the following tools:

- [Node (>= v20.18.3)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

## Quickstart

To get started with Scaffold-Yeet, follow the steps below:  

1. Clone the latest Scaffold-Yeet and initialize it.

```
git clone https://github.com/idiom-bytes/scaffold-yeet.git
cd scaffold-yeet/
yarn install
```

This will install all the necessary packages and dependencies, so it might take a while.

2. Run a local network in the first terminal:

```
yarn chain
```

This command starts a local Ethereum network that runs on your local machine and can be used for testing and development. Learn how to [customize your network configuration](https://docs.scaffoldeth.io/quick-start/environment#1-initialize-a-local-blockchain).

3. On a second terminal, deploy the test contract:

```
yarn deploy
```

This command deploys a test smart contract to the local network. You can find more information about how to customize your contract and deployment script in our [documentation](https://docs.scaffoldeth.io/quick-start/environment#2-deploy-your-smart-contract).

4. On a third terminal, start your NextJS app:

```
yarn start
```

Visit your app on: `http://localhost:3000`. You can interact with your smart contract using the `Debug Contracts` page. You can tweak the app config in `packages/nextjs/scaffold.config.ts`.

Run smart contract test with `yarn hardhat:test`

- Edit your smart contracts in `packages/hardhat/contracts`
- Edit your frontend homepage at `packages/nextjs/app/page.tsx`. For guidance on [routing](https://nextjs.org/docs/app/building-your-application/routing/defining-routes) and configuring [pages/layouts](https://nextjs.org/docs/app/building-your-application/routing/pages-and-layouts) checkout the Next.js documentation.
- Edit your deployment scripts in `packages/hardhat/deploy`

## 🚀 Setup Ponder Extension

This extension allows to use Ponder (https://ponder.sh/) for event indexing on an SE-2 dapp.

Ponder is an open-source framework for blockchain application backends. With Ponder, you can rapidly build & deploy an API that serves custom data from smart contracts on any EVM blockchain.

### Config

Ponder config (```packages/ponder/ponder.config.ts```) is set automatically from the deployed contracts and using the first blockchain network setup at ```packages/nextjs/scaffold.config.ts```.

### Design your schema

You can define your Ponder data schema on the file at ```packages/ponder/ponder.schema.ts``` following the Ponder documentation (https://ponder.sh/docs/schema).

### Indexing data

You can index events by adding files to ```packages/ponder/src/``` (https://ponder.sh/docs/indexing/write-to-the-database)

### Start the development server

Run ```yarn ponder:dev``` to start the Ponder development server, for indexing and serving the GraphQL API endpoint at http://localhost:42069

### Test your app

[Visit the ponder page inside your app](http://localhost:3000/ponder-greetings) to view all contract events that were indexed by your Ponder service.

### Query the GraphQL API

With the dev server running, open http://localhost:42069 in your browser to use the GraphiQL interface. GraphiQL is a useful tool for exploring your schema and testing queries during development. (https://ponder.sh/docs/query/graphql)

You can query data on a page using ```@tanstack/react-query```. Check the code at ```packages/nextjs/app/greetings/page.ts``` to get the greetings updates data and show it.

### Deploy

To deploy the Ponder indexer please refer to the Ponder Deploy documentation https://ponder.sh/docs/production/deploy

At **Settings** -> **Deploy** -> you must set **Custom Start Command** to ```yarn ponder:start```.

For faster indexing, you can add the ***startBlock*** to each deployed contract on the file ```packages/nextjs/contracts/deployedContracts.ts```.

And then you have to set up the ```NEXT_PUBLIC_PONDER_URL``` env variable on your SE-2 dapp to use the deployed ponder indexer.

## 🚪 Farcaster

Farcaster is a decentralized social network that let's you build native integrations directly on them.

This project already comes with a farcaster miniapp ready to go.

After getting your NextJS app running, you should simulate it being deployed on a server so you can test the farcaster app in preview mode.

1. Run ngrok from scaffold-yeet/

`ngrok http 300`

2. Copy your .env.example -> .env

3. Modify NEXT_PUBLIC_URL to be your ngrok url

`NEXT_PUBLIC_URL=http://randomip.ngrok-free.app`

4. Open the online frames.js debugger in a browser

https://debugger.framesjs.org/

5. Paste your ngrok url, including the farcaster endpoint

`http://randomip.ngrok-free.app/farcaster`

That's it, you can now build your miniapp!

## 🥷 Privy

We believe Privy to be a great service but can be very costly if you aren't well funded and are trying to build viral apps.  

Please [note their pricing tiers](https://www.privy.io/pricing) and [reach out to their sales department](mailto:sales@privy.io) for additional answers.

### To setup Privy

1. Create an app on Privy

Login to your [dashboard](https://dashboard.privy.io) and create a new client app.

2. Update your nextjs `.env`

Set `NEXT_PUBLIC_PRIVY_API_KEY` to be your AppID

3. Modify `PrivyScaffoldProvider.tsx`

Change from
```
appId="cm09stjha011x8j4lpu8gt9jt"
```

To
```
appId=NEXT_PUBLIC_PRIVY_API_KEY
```

4. Inside your app, visit the page and login via Privy

You can now login via the [Privy login page](localhost:3000/privy-login)

### To remove Privy

1. Delete the following folders and files

```
packages/nextjs/app/privy-login/
packages/nextjs/app/PrivyScaffoldProvider.tsx
```

2. Delete the followiing lines from `ScaffoldEthAppWithProviders.tsx`

```
import { PrivyScaffoldProvider } from "./PrivyScaffoldProvider";
...
<PrivyScaffoldProvider>
...
</PrivyScaffoldProvider>
```

3. Delete from `.env.example`

```
NEXT_PUBLIC_PRIVY_API_KEY=
```

4. Delete from `packages/nextjs/package.json`

```
"@privy-io/react-auth": "latest",
``` 

## Documentation

Visit our [docs](https://docs.scaffoldeth.io) to learn all the technical details and guides of Scaffold-ETH 2.

To know more about its features, check out our [website](https://scaffoldeth.io).

## Contributing to Scaffold-ETH 2

We welcome contributions to Scaffold-ETH 2!

Please see [CONTRIBUTING.MD](https://github.com/scaffold-eth/scaffold-eth-2/blob/main/CONTRIBUTING.md) for more information and guidelines for contributing to Scaffold-ETH 2.
