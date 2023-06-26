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

### Testing

(To be updated)


## Specifications

### The use of IPFS

To maintain the consistency of decentralize concept, this project uses IPFS for data storage as much as possible, including: 

* NFT Metadata
* Watch History of User

### Contract

* ABI File for the contract
  * can be found on Etherscan of the contract
