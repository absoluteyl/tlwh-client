# the Last Watch Hist Client

## Prerequisites

- Ruby 3.2.2
- Rails 7.0.5
- Infura API credentials for:
  - IPFS
  - RPC


## Development

Clone this project from Github

```bash
git clone git@github.com:absoluteyl/tlwh-client.git
```

### Install dependencies

```bash
bundle install
yarn install
```

### Database Migration

```bash
rails db:create db:migrate
```

### Configure environment variables

copy `.env.example` to `.env` and set the environment variables of your own.

```bash
cp .env.example .env

# reload after configured
cd .
```

### Start the server

Since Rails uses webpack by default after 6.1, we need to start both rails server and webpack compile server. So we use `foreman` to start both of them.

```bash
foreman start

# or with a specific Procfile
foreman start -f Procfile.dev

# or start them separately
rails s
bin/webpack-dev-server
```

### Testing

(To be updated)


## Specifications

### The use of IPFS

To maintain the consistency of decentralize concept, this project uses IPFS to store NFT Metadata. And keep data storage as simple as possible.

### Contract

* ABI File for the contract
  * can be found on Etherscan of the contract
