<template>
  <ValidationObserver>
    <v-card class="mx-auto mt-5 pa-5" width="400px">
      <v-card-title>
        <h1 class="login-title">
          ログイン
        </h1>
      </v-card-title>
      <v-card-text>
        <v-form>
          <p v-if="error" class="errors">
            {{ error }}
          </p>
          <TextField
            v-model="email"
            label="メールアドレス"
            rules="max:255|required|email"
          />
          <TextField
            v-model="password"
            label="パスワード"
            rules="required|min:6"
            :type="show1 ? 'text' : 'password'"
            :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
            vid="password"
            @click:append="show1 = !show1"
          />
          <v-card-actions>
            <nuxt-link
              to="/resettingpassword"
              class="body-2 text-decoration-none"
            >
              パスワードを忘れた?
            </nuxt-link>
          </v-card-actions>
          <v-row justify="center">
            <v-btn
              color="blue lighten-3"
              class="mx-auto white--text mt-4"
              @click="login"
            >
              ログイン
            </v-btn>
          </v-row>
        </v-form>
      </v-card-text>
    </v-card>
  </ValidationObserver>
</template>

<script>
import firebase from '@/plugins/firebase'

export default {
  fetch ({ redirect, store }) {
    if (store.state.currentUser) {
      return redirect('/')
    }
  },
  data () {
    return {
      email: '',
      password: '',
      show1: false,
      error: ''
    }
  },
  methods: {
    login () {
      firebase.auth().signInWithEmailAndPassword(this.email, this.password)
        .then(() => {
          this.$store.commit('setFlash', {
            status: true,
            message: 'ログインしました'
          })
          setTimeout(() => {
            this.$store.commit('setFlash', {})
          }, 2000)
          this.$router.replace('/')
        })
        .catch((error) => {
          this.error = ((code) => {
            switch (code) {
              case 'auth/user-not-found':
                return 'メールアドレスが間違っています'
              case 'auth/wrong-password':
                return 'パスワードが正しくありません'
              default:
                return 'メールアドレスとパスワードをご確認ください'
            }
          })(error.code)
        })
    }
  }
}
</script>

<style type="scoped">
.login-title {
  font-size: 24px;
}
</style>
