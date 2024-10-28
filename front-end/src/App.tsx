import { useState } from "react";
import "./App.css";
import { type Address, type Hash, createWalletClient, custom } from "viem";
import { goerli } from "viem/chains";
import "viem/window";

const walletClient = createWalletClient({
  chain: goerli,
  transport: custom(window.ethereum!),
});

function App() {
  const [account, setAccount] = useState<Address>();
  const [signature, setSignature] = useState<Hash>();

  const connect = async () => {
    const [address] = await walletClient.requestAddresses();
    setAccount(address);
  };

  const signTypedData = async () => {
    if (!account) return;
    const _signature = await walletClient.signTypedData({
      account,
      domain: {
        name: "EtherMail",
        version: "1",
        chainId: 31337,
        verifyingContract: "0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f", // might change later
      },
      types: {
        Person: [
          { name: "name", type: "string" },
          { name: "wallet", type: "address" },
        ],
        Mail: [
          { name: "from", type: "Person" },
          { name: "to", type: "Person" },
          { name: "contents", type: "string" },
        ],
      },
      primaryType: "Mail",
      message: {
        from: {
          name: "Cow",
          wallet: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
        },
        to: {
          name: "Bob",
          wallet: "0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB",
        },
        contents: "Hello, Bob!",
      },
    });
    setSignature(_signature);
  };

  if (account)
    return (
      <>
        <div>Connected: {account}</div>
        <button onClick={signTypedData}>Sign Typed Data</button>
        {signature && <div>Receipt: {signature}</div>}
      </>
    );

  return <button onClick={connect}>Connect Wallet</button>;
}

export default App;

//0x61d3c1c6a4b2498af87614e74632bf05468e27b4be29853f336ba045c44b04927c75a189983288cb480bd694566896bb74449ac18e859ea2c24a2ff8d0e4ad041b
