const path = require('path');
const source = path.resolve(__dirname, 'src');

module.exports = {
  context: __dirname,
  entry: {
    quickstatements: [
      './src/quickstatements.js',
      './src/vue.js',
    ],
  },
  output: {
    path: path.resolve(__dirname, 'public_html'),
    filename: '[name].js',
  },
  resolve: {
        alias: {
        'node_modules': path.join(__dirname, 'node_modules'),
        'bower_modules': path.join(__dirname, 'bower_modules'),
    }
  },
  };