<template>
  <div>
    <v-navigation-drawer
      v-if="loggedIn"
      v-model="drawer"
      app
      clipped
      mobile-breakpoint="2000"
    >
      <LoggedInNavDrawer />
    </v-navigation-drawer>
    <v-app-bar
      app
      light
      clipped-left
    >
      <v-app-bar-nav-icon
        v-if="loggedIn"
        @click="drawer=!drawer"
      />
      <nuxt-link
        to="/"
        class="black--text"
        style="text-decoration:none;"
      >
        <AppLogo />
      </nuxt-link>
      <v-toolbar-title
        v-not-visible="'tablet'"
        @:click="show('tablet')"
      >
        {{ appName }}
      </v-toolbar-title>
      <v-spacer />
      <div class="header-list">
        <div v-if="!loggedIn" class="before-login-box">
          <v-btn
            v-if="!currentUser"
            to="/login"
            text
            color="black"
            :outlined="true"
            small
          >
            ログイン
          </v-btn>
          <v-btn
            v-if="!currentUser"
            to="/signup"
            text
            color="black"
            :outlined="true"
            small
          >
            新規登録
          </v-btn>
        </div>
        <div v-if="loggedIn" class="after-login-box">
          <v-menu
            offset-y
            dense
            nav
            clipped-right
          >
            <template v-slot:activator="{on, attrs}">
              <v-avatar>
                <img
                  v-if="currentUser.avatar_url"
                  :src="currentUser.avatar_url"
                  alt="Avatar"
                  v-bind="attrs"
                  v-on="on"
                >
                <v-icon
                  v-else
                  size="48"
                  color="light-blue"
                  alt="Avater"
                  v-bind="attrs"
                  v-on="on"
                >
                  mdi-account-circle
                </v-icon>
              </v-avatar>
            </template>
            <v-list
              dense
            >
              <v-subheader>
                ログイン中のユーザー
              </v-subheader>
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-subtitle>
                    {{ currentUser.name }}
                  </v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
              <v-divider />
              <v-list-item
                v-for="(link, l) in links"
                :key="l"
                :to="link.to"
                exact
              >
                <v-list-item-icon class="mr-2">
                  <v-icon size="22" v-text="link.icon" />
                </v-list-item-icon>
                <v-list-item-title>{{ link.name }}</v-list-item-title>
              </v-list-item>
            </v-list>
            <v-divider />
            <v-list
              dense
            >
              <v-list-item key="logout" @click="logOut">
                <v-icon>mdi-logout-variant</v-icon>
                <v-list-item-title>ログアウト</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </div>
      </div>
    </v-app-bar>
  </div>
</template>

<script>
import firebase from '@/plugins/firebase'

export default {
  data () {
    return {
      appName: 'PUSHAR',
      drawer: null
    }
  },
  computed: {
    currentUser () {
      return this.$store.state.currentUser
    },
    links () {
      const links = [
        {
          name: 'マイページ',
          to: `/users/${this.currentUser.id}`,
          icon: 'mdi-account'
        },
        {
          name: 'ユーザー編集',
          to: '/users/edit',
          icon: 'mdi-account-cog'
        },
        {
          name: 'プロフィール編集',
          to: '/users/profile',
          icon: 'mdi-file-document-edit'
        }
      ]
      return links
    },
    loggedIn () {
      return this.$store.state.loggedIn
    }
  },
  methods: {
    logOut () {
      firebase
        .auth()
        .signOut()
        .then(() => {
          this.$store.commit('setFlash', {
            status: true,
            message: 'ログアウトしました'
          })
          setTimeout(() => {
            this.$store.commit('setFlash', {})
          }, 1500)
          this.$router.push('/login')
        })
    },
    show (str) {
      alert(str)
    }
  }
}
</script>

<style type="scoped">
.app-title {
 margin-left: 200px;
 font-size: 1.5em;
 letter-spacing: 2px;
}

.header-list {
   display: flex;
   margin-right: 50px;
}
