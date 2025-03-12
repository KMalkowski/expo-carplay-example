require("ts-node/register");
import { ExpoConfig } from "expo/config";

const config: ExpoConfig = {
  name: "wolniej",
  slug: "wolniej",
  version: "1.0.0",
  orientation: "portrait",
  icon: "./assets/images/icon.png",
  scheme: "myapp",
  userInterfaceStyle: "automatic",
  newArchEnabled: true,
  ios: {
    supportsTablet: true,
    bundleIdentifier: "com.kmalkowski.wolno",
  },
  android: {
    adaptiveIcon: {
      foregroundImage: "./assets/images/adaptive-icon.png",
      backgroundColor: "#ffffff",
    },
    package: "com.kmalkowski.wolno",
  },
  web: {
    bundler: "metro",
    output: "static",
    favicon: "./assets/images/favicon.png",
  },
  plugins: [
    require("./plugins/carplay/withCarPlay").withCarPlay,
    "expo-router",
  ],
  experiments: {
    typedRoutes: true,
  },
};

export default config;
