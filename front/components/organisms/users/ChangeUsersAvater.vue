<template>
  <ValidationObserver ref="obs" v-slot="ObserverProps">
    <div class="user-avatar-box">
      <h3 class="edit-h3">
        アバター画像
      </h3>
      <v-row justify="center">
        <v-avatar
          v-if="uploadImageUrl"
          size="62"
        >
          <img
            v-if="uploadImageUrl"
            :src="uploadImageUrl"
            alt="Avater"
          >
          <img
            v-else-if="value"
            :src="value"
            alt="Avater"
          >
          <v-icon
            v-else
            size="62"
            color="light-blue"
            alt="Avater"
          >
            mdi-account-circle
          </v-icon>
        </v-avatar>
      </v-row>
      <FileInput
        v-model="avatar"
        label="画像をアップロードしてください"
        accept="image/*"
        :rules="rules"
        @change="onImagePicked"
      />
      <p v-if="error" class="errors">
        {{ error }}
      </p>
      <v-row justify="end">
        <v-btn
          color="black lighten-3"
          class="white--text"
          :disabled="ObserverProps.invalid || !ObserverProps.validated"
          @click="changeUsersAvatar"
        >
          変更
        </v-btn>
      </v-row>
    </div>
  </ValidationObserver>
</template>

<script>
import axios from '@/plugins/axios'
import FileInput from '~/components/atoms/FileInput.vue'

export default {
  components: {
    FileInput
  },
  props: {
    rules: {
      type: [Object, String],
      default: ''
    }
  },
  data () {
    return {
      avatar: [],
      uploadImageUrl: '',
      error: ''
    }
  },
  computed: {
    currentUser () {
      return this.$store.state.currentUser
    }
  },
  methods: {
    onImagePicked (file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf('.') <= 0) {
          return
        }
        const fr = new FileReader()
        fr.readAsDataURL(file)
        fr.addEventListener('load', () => {
          this.uploadImageUrl = fr.result
        })
      } else {
        this.uploadImageUrl = ''
      }
    },
    changeUsersAvatar () {
      const formData = new FormData()
      formData.append('avatar', this.avatar)
      const headers = {
        'content-type': 'multipart/form-data'
      }
      axios
        .patch(`/v1/users/${this.currentUser.id}/update_avatar`, formData, { headers })
        .then((res) => {
          this.avatar = res.data.avatar
          this.$store.commit('setUserAvatarUrl', res.data.avatar_url)
          this.$store.commit('setFlash', {
            status: true,
            message: 'アバターを変更しました'
          })
          setTimeout(() => {
            this.$store.commit('setFlash', {})
          }, 2000)
        })
        .catch((error) => {
          this.error = ((code) => {
            switch (code) {
              default:
                return 'ファイルがセットされているか確認してください'
            }
          })(error.code)
        })
    }
  }
}
</script>
