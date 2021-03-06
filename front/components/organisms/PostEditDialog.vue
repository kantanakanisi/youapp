<template>
  <v-dialog
    v-model="dialogStatus"
    width="500px"
    persistent
  >
    <v-card width="500px" class="mx-auto">
      <v-toolbar flat>
        <v-toolbar-title>
          投稿編集
        </v-toolbar-title>
        <v-spacer />
        <v-btn
          icon
          @click="closeDialog"
        >
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-form>
        <ValidationObserver ref="obs" v-slot="{ invalid }">
          <div class="mt-2 pa-3">
            <TextField
              v-model="title"
              label="例) Rails+Docker+Nuxt (短的に分かりやすく)"
              rules="max:80|required"
            />
            <AddLink
              rules="regex:https?://([\w-]+\.)+[\w-]+(/[\w- .?%&=]*)?"
              label="URL"
              :first-url.sync="firstUrl"
              :second-url.sync="secondUrl"
              :third-url.sync="thirdUrl"
            />
            <TextArea
              v-model="point"
              label="例) ログイン機能実装の参考になりました (自身の体験を踏まえて)"
              rules="max:140|required"
              :counter="140"
            />
            <v-row justify="center">
              <p v-if="error" class="errors">
                {{ error }}
              </p>
            </v-row>
            <v-row justify="center">
              <v-btn
                color="white lighten-3"
                class="black--text"
                :disabled="invalid"
                @click="updatePost"
              >
                編集
              </v-btn>
            </v-row>
          </div>
        </ValidationObserver>
      </v-form>
    </v-card>
  </v-dialog>
</template>

<script>
import axios from '@/plugins/axios'

export default {
  props: {
    dialog: {
      type: Boolean,
      required: true
    }
  },
  data () {
    return {
      dialogStatus: this.dialog,
      title: '',
      point: '',
      firstUrl: '',
      secondUrl: '',
      thirdUrl: '',
      error: ''
    }
  },
  computed: {
    currentUser () {
      return this.$store.state.currentUser
    },
    links () {
      const links = [this.firstUrl, this.secondUrl, this.thirdUrl]
      return links
    }
  },
  watch: {
    dialog (newValue) {
      this.dialogStatus = newValue
    }
  },
  mounted () {
    axios
      .get(`/v1/posts/${this.$route.params.id}`)
      .then((res) => {
        this.title = res.data.title
        this.point = res.data.point
      })
      .catch((error) => {
        if (error.response.status === 404) {
          this.notFound = true
        }
      })
  },
  methods: {
    updatePost () {
      this.$store.commit('setLoading', true)
      axios
        .patch(`/v1/posts/${this.$route.params.id}`, {
          title: this.title,
          user_id: this.currentUser.id,
          links: this.links,
          point: this.point
        })
        .then((res) => {
          this.$store.commit('setLoading', false)
          this.$store.commit('setFlash', {
            status: true,
            message: '投稿を編集しました'
          })
          setTimeout(() => {
            this.$store.commit('setFlash', {})
          }, 2000)
          this.$router.replace(`/users/${this.$store.state.currentUser.id}`)
        })
        .catch((error) => {
          this.error = ((code) => {
            switch (code) {
              default:
                return '投稿内容を確認してください'
            }
          })(error.code)
          this.$store.commit('setLoading', false)
        })
    },
    closeDialog () {
      this.$emit('closeDialog')
    }
  }
}
</script>
