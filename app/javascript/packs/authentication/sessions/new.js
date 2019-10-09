import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';

import AuthenticationSessionsNewView from 'views/authentication/sessions/new.vue';

Vue.use(ElementUI);

const integrationIndex = new Vue({
  el: '#authentication-sessions-new-view',
  components: {
    'authentication-sessions-new-view': AuthenticationSessionsNewView,
  }
});
