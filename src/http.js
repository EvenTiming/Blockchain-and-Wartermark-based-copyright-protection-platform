// http.js
const axios = require('axios');

// 创建 axios 实例
const instance = axios.create({
  baseURL: 'http://localhost:9090'
});
// 导出 axios 实例
module.exports = instance;