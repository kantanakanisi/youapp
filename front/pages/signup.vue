<template>
  <ValidationObserver>
    <v-card class="mx-auto mt-5 pa-5" width="400px">
      <v-card-title>
        <h1 class="signup-title">
          新規登録
        </h1>
      </v-card-title>
      <v-card-text>
        <v-form>
          <p v-if="error" class="errors">
            {{ error }}
          </p>
          <TextField
            v-model="name"
            label="名前"
            rules="max:20|required"
          />
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
          <TextField
            v-model="passwordConfirm"
            label="パスワード(再入力)"
            rules="required|min:6|confirmed:パスワード"
            :type="show2 ? 'text' : 'password'"
            :append-icon="show2 ? 'mdi-eye' : 'mdi-eye-off'"
            @click:append="show2 = !show2"
          />
          <v-row justify="center">
            <v-btn
              color="green lighten-3"
              class="mx-auto white--text mt-4"
              @click="signup"
            >
              新規登録
            </v-btn>
          </v-row>
        </v-form>
      </v-card-text>
    </v-card>
  </ValidationObserver>
</template>

<script>
import axios from '@/plugins/axios'
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
      name: '',
      password: '',
      passwordConfirm: '',
      show1: false,
      show2: false,
      error: ''
    }
  },
  methods: {
    signup () {
      this.$store.commit('setLoading', true)
      firebase
        .auth()
        .createUserWithEmailAndPassword(this.email, this.password)
        .then((res) => {
          const user = {
            email: res.user.email,
            name: this.name,
            uid: res.user.uid
          }
          axios.post('/v1/users', { user }).then((res) => {
            this.$store.commit('setLoading', false)
            this.$store.commit('setUser', res.data)
            this.$store.commit('setFlash', {
              status: true,
              message: 'ログインしました'
            })
            setTimeout(() => {
              this.$store.commit('setFlash', {})
            }, 2000)
            this.$router.replace('/')
          })
        })
        .catch((error) => {
          this.error = ((code) => {
            switch (code) {
              case 'auth/email-already-in-use':
                return '既に登録されたメールアドレスです'
              case 'auth/wrong-password':
                return 'パスワードが正しくありません'
              case 'auth/weak-password':
                return 'パスワードは6文字以上必須です'
              default:
                return 'メールアドレスとパスワードをご確認ください'
            }
          })(error.code)
          this.$store.commit('setLoading', false)
        })
    }
  }
}
</script>

<style type="scoped">
.signup-title {
  font-size: 24px;
}
</style>
