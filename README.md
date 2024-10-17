# node-keygen-besu

This repository contains a key generation script for Hyperledger Besu nodes.

## Usage

### Prerequisites

Before running the key generation script, ensure you have the following installed:

- Docker

### Generating Keys

To generate keys for a Besu node, run the following command:

```bash
./generate.sh <number-of-node> <algorithm>
```

**Example command**
```bash
./generate.sh 4 QBFT
```

algorithm that support is `QBFT` and `IBFT`

This will execute the key generation script and create the necessary keys for your node.

### Cleaning Up

To clean up the generated keys, you can use the following command:

```bash
./clean.sh
```

This will remove the generated keys and any associated files.

## License

This project is licensed under the [NONE](LICENSE).

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues if you encounter any problems or have suggestions for improvements.

Feel free to adjust the content as needed for your specific repository!
