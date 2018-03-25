const webpack = require('webpack');
const path = require('path');

config = {
    entry: './src/client/vendors.coffee',

    output: {
        path: path.resolve(__dirname, "src/static"),
        filename: 'js/vendors.dist.js'
    },

    plugins: [
        new webpack.ProvidePlugin({
            $: "jquery/dist/jquery.min.js",
            jQuery: "jquery/dist/jquery.min.js",
            "window.jQuery": "jquery/dist/jquery.min.js"
        })
    ],

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
                options: { name: "./fonts/[name].[ext]" }
            },
            {
                test: /\.(jpe?g|png|gif)$/i,
                loader: "file-loader",
                query: {
                    name: '[name].[ext]',
                    outputPath: './img/'
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
            }
        ]
    },

    mode: 'development'
}

module.exports = config;