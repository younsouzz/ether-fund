import React, { useState, useEffect } from "react";
import { ethers } from "ethers";

const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // adresse déployée localement

const abi = [
  "function getBalance() public view returns (uint256)",
  "function withdraw() public",
  "receive() external payable",
];

function App() {
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [contract, setContract] = useState(null);
  const [balance, setBalance] = useState("0");
  const [amount, setAmount] = useState("");

  useEffect(() => {
    if (window.ethereum) {
      const prov = new ethers.BrowserProvider(window.ethereum);
      setProvider(prov);
    } else {
      alert("Please install MetaMask!");
    }
  }, []);

  useEffect(() => {
    if (provider) {
      provider.send("eth_requestAccounts", []).then(() => {
        const signer = provider.getSigner();
        setSigner(signer);
        const cont = new ethers.Contract(contractAddress, abi, signer);
        setContract(cont);
      });
    }
  }, [provider]);

  const fetchBalance = async () => {
    if (contract) {
      const bal = await contract.getBalance();
      setBalance(ethers.formatEther(bal));
    }
  };

  const sendEther = async () => {
    if (!amount || isNaN(amount)) {
      alert("Enter a valid amount");
      return;
    }
    try {
      const tx = await signer.sendTransaction({
        to: contractAddress,
        value: ethers.parseEther(amount),
      });
      await tx.wait();
      alert("Ether sent!");
      fetchBalance();
    } catch (error) {
      alert("Transaction failed: " + error.message);
    }
  };

  const withdraw = async () => {
    try {
      const tx = await contract.withdraw();
      await tx.wait();
      alert("Withdraw successful!");
      fetchBalance();
    } catch (error) {
      alert("Withdraw failed: " + error.message);
    }
  };

  useEffect(() => {
    if (contract) fetchBalance();
  }, [contract]);

  return (
    <div style={{ padding: 20, fontFamily: "Arial" }}>
      <h1>Ether Fund</h1>
      <p>
        <strong>Contract balance:</strong> {balance} ETH
      </p>
      <input
        type="text"
        placeholder="Amount in ETH"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        style={{ marginRight: 10 }}
      />
      <button onClick={sendEther}>Send Ether to Contract</button>
      <hr />
      <button onClick={withdraw}>Withdraw (Owner only)</button>
    </div>
  );
}

export default App;
