// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require("prism-react-renderer/themes/github");
const darkCodeTheme = require("prism-react-renderer/themes/dracula");

/** @type {import("@docusaurus/types").Config} */
const config = {
  title: "CutiePy",
  url: "https://cutiepy.org",
  baseUrl: "/",
  favicon: "img/favicon.ico",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  trailingSlash: false,

  // GitHub pages deployment config.
  // If you aren"t using GitHub pages, you don"t need these.
  organizationName: "chenbobby", // Usually your GitHub org/user name.
  projectName: "cutiepy", // Usually your repo name.

  // Even if you don"t use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      /** @type {import("@docusaurus/preset-classic").Options} */
      ({
        docs: {
          routeBasePath: "/",
          sidebarPath: require.resolve("./sidebars.js"),
          editUrl:
            "https://github.com/chenbobby/cutiepy/tree/main/cutiepy_website/",
        },
        blog: {
          showReadingTime: true,
          editUrl:
            "https://github.com/chenbobby/cutiepy/tree/main/cutiepy_website/",
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import("@docusaurus/preset-classic").ThemeConfig} */
    ({
      navbar: {
        title: "CutiePy",
        logo: {
          alt: "My Site Logo",
          src: "img/logo.svg",
        },
        items: [
          {
            type: "doc",
            docId: "index",
            position: "left",
            label: "Documentation",
          },
          { to: "/blog", label: "Blog", position: "right" },
          { to: "/about", label: "About", position: "right" },
          {
            href: "https://github.com/chenbobby/cutiepy",
            label: "Source Code",
            position: "right",
          },
        ],
      },
      footer: {
        style: "dark",
        links: [
          {
            title: "Docs",
            items: [
              {
                label: "Home",
                to: "/",
              },
              {
                label: "Quickstart",
                to: "/quickstart",
              },
              {
                label: "Tutorial",
                to: "/tutorial",
              },
              {
                label: "Explanations",
                to: "/explanations",
              },
              {
                label: "API Reference",
                to: "/reference",
              },
            ],
          },
          {
            title: "Community",
            items: [
              {
                label: "GitHub Discussions",
                href: "https://github.com/chenbobby/cutiepy/discussions"
              },
            ],
          },
          {
            title: "Learn More",
            items: [
              {
                label: "About",
                to: "/about",
              },
              {
                label: "Blog",
                to: "/blog",
              },
              {
                label: "Source Code",
                href: "https://github.com/cutiepy/cutiepy",
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Bobby Chen.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
        magicComments: [
          // Remember to extend the default highlight class name as well!
          {
            className: 'theme-code-block-highlighted-line',
            line: 'highlight-next-line',
            block: { start: 'highlight-start', end: 'highlight-end' },
          },
          {
            className: 'code-block-highlighted-line--green',
            line: 'highlight-next-line-green',
            block: { start: 'highlight-start-green', end: 'highlight-end-green' },
          },
        ],
      },
    }),
};

module.exports = config;
