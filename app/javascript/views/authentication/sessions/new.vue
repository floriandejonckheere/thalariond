<script>
  import CSRF from 'components/shared/csrf.vue';

  export default {
    components: {
      csrf: CSRF
    },
    props: {
      errors: Array
    },
    data: function () {
      return ({
        user: {
          email: '',
          password: ''
        },
        rules: {
          email: [
            { type: 'email', trigger: 'blur,change' }
          ]
        }
      });
    }
  }
</script>

<template>
  <div>
    <el-alert v-for="error in errors"
              type="error"
              :title="error"
              :closable="false"
    >
    </el-alert>
    <el-container class="bg-light" style="height: 100vh;">
      <el-main class="m-t-10">
        <el-row type="flex" justify="center">
          <el-col :xs="24" :sm="6">
            <el-header>
              <h3>Sign in to continue</h3>
            </el-header>
            <el-form :model="user" :rules="rules" label-position="top" method="post" action="/users/sign_in">
              <csrf></csrf>

              <el-form-item label="Email" prop="email" required>
                <el-input name="user[email]" v-model="user.email" type="email"></el-input>
              </el-form-item>

              <el-form-item label="Password" prop="password" required>
                <el-input v-model="user.password" name="user[password]" type="password" autocomplete="off"></el-input>
              </el-form-item>

              <el-form-item>
                <el-button native-type="submit" type="primary" class="m-t-10" style="width: 100%;">
                  Sign in
                </el-button>
              </el-form-item>
            </el-form>
          </el-col>
        </el-row>
      </el-main>
    </el-container>
  </div>
</template>

<style scoped>
</style>
