const webpack = require('webpack');
const path = require('path');

config = {
    entry: './src/client/vendors.js',

    output: {
        path: path.resolve(__dirname, "src/static"),
        filename: 'js/vendors.dist.js',
        publicPath: '/'
    },

    module: {
        rules: [
            {
                test: /\.coffee$/,
                use: ['coffee-loader']
            },
            {
                test: /\.css$/,
                use: ['style-loader', 'css-loader']
            },
            {
                test: /\.(svg|ttf|eot|woff|woff2)$/,
                loader: "file-loader",
                options: {
                    name: "./fonts/[name].[ext]",
                }
            },
            {
                test: /\.(jpe?g|png|gif)$/i,
                loader: "file-loader",
                query: {
                    name: './img/[name].[ext]',
                }
            },
            {
                test: require.resolve('jquery'),
                use: [
                    {
                        loader: 'expose-loader',
                        options: 'jQuery'
                    },
                    {
                        loader: 'expose-loader',
                        options: '$'
                    },
                ]
            },
            {
                test: require.resolve('typeahead.js/dist/bloodhound.min.js'),
                use: {
                    loader: 'expose-loader',
                    options: 'Bloodhound'
                },
            },
            {
                test: require.resolve('raphael'),
                use: {
                    loader: 'expose-loader',
                    options: 'Raphael'
                },
            },
            {
                test: require.resolve('moment'),
                use: {
                    loader: 'expose-loader',
                    options: 'moment'
                },
            }

        ]
    },

    // mode: 'development'
}

module.exports = config;