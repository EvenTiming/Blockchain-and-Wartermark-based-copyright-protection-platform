import { createStore } from 'vuex';

// 创建一个新的 Vuex store 实例
const store = createStore({
  // 在这里定义你的全局状态和方法
  state: {
    // 状态
    Islogin: false,
  },
  mutations: {
    // 方法
  },
  actions: {
    // 异步修改全局变量方法
  },
});

export default store;