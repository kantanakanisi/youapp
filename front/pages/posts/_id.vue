<template>
  <div class="posts-id">
    <ErrorAnnounce
      :status="notFound"
    />
    <PostEditDialog
      :dialog="dialog"
      @closeDialog="dialog = false"
    />
    <div v-if="!notFound" class="post-show-box">
      <v-card class="mx-auto mt-4 pa-3" width="600px">
        <v-card-title>
          <h2 class="post-show-title">
            {{ post.title }}
          </h2>
        </v-card-title>
        <div class="post-show-header px-2">
          <UsersLink
            :user="user"
          />
          <div
            v-if="currentUser && currentUser.id === user.id"
            class="post-show-change-box"
          >
            <v-btn
              outlined
              fab
              small
              color="light-blue lighten-3"
              @click="dialog = !dialog"
            >
              <v-icon>mdi-pencil</v-icon>
            </v-btn>
            <v-btn
              outlined
              fab
              small
              color="red lighten-3"
              @click="destroyPost"
            >
              <v-icon>mdi-delete-forever</v-icon>
            </v-btn>
          </div>
        </div>
        <LinkCard
          v-for="link in links"
          :key="link.id"
          :link="link"
        />
        <v-card-text>
          <div class="post-index-point mt-2">
            {{ post.point }}
          </div>
        </v-card-text>
        <LikeButton
          v-if="currentUser"
          :user="post.user"
          :post="post"
        />
      </v-card>
    </div>
  </div>
</template>

<script>
import axios from '@/plugins/axios'

export default {
  data () {
    return {
      user: {},
      post: {},
      point: '',
      links: [],
      notFound: false,
      dialog: false
    }
  },
  computed: {
    currentUser () {
      return this.$store.state.currentUser
    }
  },
  mounted () {
    axios
      .get(`/v1/posts/${this.$route.params.id}`)
      .then((res) => {
        this.user = res.data.user
        this.post = res.data
        this.point = res.data.point
        this.links = res.data.links
      })
      .catch((error) => {
        if (error.response.status === 404) {
          this.notFound = true
        }
      })
  },
  methods: {
    openDialog () {
      this.dialog = true
    },
    destroyPost () {
      this.$store.commit('setLoading', true)
      axios
        .delete(`/v1/posts/${this.$route.params.id}`, { id: this.user.id })
        .then((res) => {
          this.$store.commit('setLoading', false)
          this.$store.commit('setFlash', {
            status: true,
            message: '投稿を削除しました'
          })
          setTimeout(() => {
            this.$store.commit('setFlash', {})
          }, 2000)
          this.$router.replace('/')
        })
    }
  }
}
</script>

<style type="scoped">
.post-point {
  margin-top: 24px;
}

.post-show-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
