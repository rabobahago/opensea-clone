import { ethers } from "ethers";
import { useEffect, useState } from "react";
import axios from "axios";
import styles from "../styles/Home.module.css";
import Market from "../artifacts/contracts/NFTMarket.sol/NFTMarket.json";
import NFT from "../artifacts/contracts/NFT.sol/NFT.json";
const { nftaddress, nftmarketaddress } = require("../config");
const API_KEY = process.env.API_KEY;
let network = "goerli";
export default function Home() {
  const [nfts, setNfts] = useState([]);
  const [loadingState, setLoadingState] = useState("");
  useEffect(() => {
    loadNFts();
  }, []);
  async function loadNFTs() {
    const provider = new ethers.providers.AlchemyProvider(network, API_KEY);

    const tokenContract = new ethers.Contract(nftaddress, NFT.abi, provider);
    const marketContract = new ethers.Contract(
      nftmarketaddress,
      Market.abi,
      provider
    );
    const data = await marketContract.fetchMarketItems();
    const items = await Promise.all(
      data.map(async (i) => {
        const tokenUri = await tokenContract.tokenUri(i.tokenId);
        const meta = await axios.get(tokenUri);
        const price = ethers.utils.formatUnits(i.price.toString(), "ether");
        const item = {
          price,
          tokenId: i.tokenId.toNumber(),
          seller: i.seller,
          owner: i.owner,
          image: meta.data.image,
          name: meta.data.name,
          description: meta.data.description,
        };
        return item;
      })
    );
    setNfts(items);
    setLoadingState("loaded");
  }
  async function buyNFT(nft) {
    const web3modal = new Web3Modal();
    const connection = await web3modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(nftmarketaddress, Market.abi, signer);
    const price = ethers.utils.parseUnits(nfts.price.toString(), "ether");
  }
  if (loadingState === "loaded" && !nfts.length)
    return <h1 className="px-20 py-10 text-3xl">No items in marketplace</h1>;
  return (
    <div className={styles.container}>
      <h1>Globals</h1>
    </div>
  );
}
