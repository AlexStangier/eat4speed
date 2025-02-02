import Vue from 'vue'
import Vuex from 'vuex'
import VuexPersistence from 'vuex-persist'
import Cookies from 'js-cookie'

Vue.use(Vuex)

const in2Hours = 1/12;

const vuexLocal = new VuexPersistence({
  storage: window.localStorage
})

export default new Vuex.Store({
  state: {
    searchString:"",
    gericht_ID:"",
    cartGerichte:[],
    selectedRestaurant_ID:"",
    searchType:"",
    searchOptions: {
      gericht_ID: -1,
      gerichtName: "",
      kategorien: [],
      excludedAllergene: [],
      maxMindestbestellwert: 0,
      maxEntfernung: 0,
      minBewertung: 0,
      useName: true,
      useKategorien: false,
      useAllergene: false,
      useMindestbestellwert: false,
      useEntfernung: false,
      useBewertung: false
    },
    searchOptionsRestaurant: {
      restaurantName: "",
      maxMindestbestellwert: 0,
      maxEntfernung: 0,
      minBewertung: 0,
      useName: true,
      useMindestbestellwert: false,
      useEntfernung: false,
      useBewertung: false
    }
  },
  plugins: [vuexLocal.plugin],
  mutations: {
    changeSearchType: (state, payload) => {
      state.searchType = payload;
    },
    changeSearchOptions: (state, payload) => {
      state.searchOptions = payload;
    },
    changeSearchOptionsRestaurant: (state, payload) => {
      state.searchOptionsRestaurant = payload;
    },
    changeSelectedRestaurant_ID: (state, payload) => {
      state.selectedRestaurant_ID = payload;
    },
    changeSearchString: (state, payload) => {
      state.searchString = payload;
    },
    changeGericht_ID: (state, payload) => {
      state.gericht_ID = payload;
    } ,
    addToCartGerichte: (state, payload) => {
      state.cartGerichte.push(payload);
    },
    removeFromCartGerichte: (state, payload) => {

      for(let i = 0; i<state.cartGerichte.length;i++)
      {
        if(state.cartGerichte[i].gericht_ID === payload.gericht_ID &&
            state.cartGerichte[i].quantity === payload.quantity &&
            state.cartGerichte[i].num === payload.num)
        {
          state.cartGerichte.splice(i,1);
        }
      }

    },
    changeCartGerichte: (state, payload) => {
      state.cartGerichte = payload;
    },
    saveLoginData: (state, payload) => {
      Cookies.set('emailAdresse', payload.emailAdresse, { expires: in2Hours, secure: false });
      Cookies.set('passwort', payload.passwort, { expires: in2Hours, secure: false });
    },
    deleteCartGerichte: (state) => {
      state.cartGerichte = [];
    },
  },
  actions: {
    deleteLoginDate: () => {
      Cookies.remove('emailAdresse');
      Cookies.remove('passwort');
    },
  },
  getters: {
    searchType: state => {
      return state.searchType;
    },
    searchOptions: state => {
      return state.searchOptions;
    },
    searchOptionsRestaurant: state => {
      return state.searchOptionsRestaurant;
    },
    selectedRestaurant_ID: state => {
      return state.selectedRestaurant_ID;
    },
    searchString: state => {
      return state.searchString;
    },
    gericht_ID: state => {
      return state.gericht_ID;
    },
    getCartGerichte: state => {
      return state.cartGerichte;
    },
    getLoginData: () => ({
      auth: {
        username: Cookies.get('emailAdresse'),
        password: Cookies.get('passwort')
      }
    }),
  },
  modules: {
  }
})
