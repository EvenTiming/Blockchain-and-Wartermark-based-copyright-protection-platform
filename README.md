## Blockchain and WarterMark Based copyright protection Platform

### 简要介绍：

本项目开发了一个基于区块链和数字水印的版权保护平台。功能主要为图片上链认证和图片交易，由于区块链无法存储大量数据，所以将图片保存到IPFS中，区块链中仅仅保存文件hash。项目前端由Vue开发，无后端。设计数据存储更新等操作完全在链端完成。简单来说，用以太坊和IPFS代替了传统数据库，逻辑处理主要由前端和智能合约完成。

由于是本科毕业设计，项目开发过程中完全在本地进行，本地表现良好 :)，从未在以太坊和IPFS上测试性能和花费。

项目中目前仅有平台的测试版本，且不包括水印算法。由于想实现一个完全消除中心化服务器的Dapp，所以水印应该会开发成一个本地运行的工具。

项目中涉及的图片资源均未用于商业用途，仅测试用途。

### 环境&&工具

| 功能                   | 工具                                                         |
| ---------------------- | ------------------------------------------------------------ |
| 代码编写测试           | VScode                                                       |
| 以太坊本地模拟         | [Ganache](https://trufflesuite.com/ganache/)                 |
| 智能合约编写/编译/调试 | [Remix](remix.ethereum.org), [Truffle](https://trufflesuite.com/truffle/) |
| 区块链钱包             | [MetaMask](https://microsoftedge.microsoft.com/addons/detail/metamask/ejbalbakoplchlghecdalmeeeajnimhm) |
| 前端框架               | Vue3 ,ElementUIplus                                          |
| 文件存储               | IPFS                                                         |
| 浏览器                 | Edge, Chrome                                                 |

