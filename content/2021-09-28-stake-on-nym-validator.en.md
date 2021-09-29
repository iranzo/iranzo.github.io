---
author: Pablo Iranzo Gómez
title: How to stake on NYM Validator 🐳🐳🐳
tags: NYM, crypto, fedora, Linux, CentOS, RHEL, foss, cosmos
layout: post
date: 2021-09-28 17:20:34 +0200
comments: true
category: tech
description: This article describes how to stake your token against a NYM cosmos validator
lang: en
modified: 2021-09-28T15:27:36.000Z
slug: stake-nym-validator
---

As said in the article about [mixnodes]({filename}2021-05-09-run-a-nym-mixnode.en.md) and [validators]({filename}2021-05-09-run-a-nym-validator.en.md), NYM is a technology aiming for providing privacy for the communications.

Once you get some tokens, `PUNK` at this time, you can use the web wallet to check the balance of your account and delegate it to mixnodes or gateways... but, using the binaries, you can additionally delegate to validators.

For doing this, we first need the `nymd` binary on our system to follow the procedure for compiling it from the documentation for validators, but skip the remaining parts <https://nymtech.net/docs/run-nym-nodes/validators/>.

Specifically, the binaries we're interested in are:

- `libwasmvm.so`
- `nymd`

## Restoring the wallet

When you created your wallet at <https://testnet-milhon-wallet.nymtech.net/> you got a mnemonic phrase that can be used to access it or to restore... we need that one (still keep it private and do not share with anyone).

So... first things first, we need to restore the wallet with:

`nymd --keyring-backend=os keys add youruser --recover`

Just make sure to use the proper `keyring-backend` like `os` or `file` to store the key and decide the name `youruser` for holding and referring to it with later commands.

Once the key is created (restored), it will output the `punkADDRESS` we need to use later on.

## Staking against a validator

We need to know the address of the validator, so we just need to go to the explorer <https://testnet-milhon-blocks.nymtech.net/validators> decide which one we want to stake on, and in the details page of it, get the address, for example: `punkvaloper1xq1kABCDEqumupju86ljzlj6q2lqhdz2ne76gv` and let's store it as a variable as `VALIDATOR`.

To stake, we need to also know our current balance, but as we are not running `nymd` but using it as client, we need to specify a validator with the 26657 port open:

```sh
nymd query bank balances punkADDRESS  --node "tcp://testnet-milhon-validator1.nymtech.net:26657"
```

Once we know the balance, we should get a value expressed in `upunk` and we should consider the commission for the network fees (`5000upunk`) and store as a number in a variable `BALANCE`.

Let's stake with this command:

```sh
nymd tx staking delegate --node "tcp://testnet-milhon-validator1.nymtech.net:26657" -y ${VALIDATOR}  ${BALANCE}  --from ${youruser}   --keyring-backend=os   --chain-id "testnet-milhon"   --gas="auto"   --gas-adjustment=1.15   --fees 5000upunk
```

This will add the delegation and will start appearing on the explorer for the chosen validator.

## Claiming rewards

After we staked for a while, we might be able to claim the rewards, note that this still requires 'gas' in the form of `upunk`.

First let's check again our balance with:

```sh
nymd query bank balances punkADDRESS  --node "tcp://testnet-milhon-validator1.nymtech.net:26657"
```

Let's claim the rewards:

```sh
~/.nymd/nymd  --node "tcp://testnet-milhon-validator1.nymtech.net:26657"  tx distribution withdraw-rewards -y ${VALIDATOR} --from ${youruser} --keyring-backend=os --chain-id='testnet-milhon' --gas='auto' --gas-adjustment=1.15  --fees 5000upunk
```

And let's check again the balance with

```sh
nymd query bank balances punkADDRESS  --node "tcp://testnet-milhon-validator1.nymtech.net:26657"
```

If everything went fine, and we got the tokens there for a while, we should see a growing number of tokens back, that... can be delegated again.

!!! warning

    Each transaction requires to pay a fee, so do not try to hurry too much until you make an estimation on how is the staking rewards going on.

Enjoy!
