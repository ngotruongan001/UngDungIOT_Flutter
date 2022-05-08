const mongoose = require('mongoose');

const MessageSchema = new mongoose.Schema(
    {
        description: {
            type: String,
            required: true,
        },
        readed:{
            type: Boolean,
            default: false
        }
        
    },
    { timestamps: true },
);

module.exports = mongoose.model('Message', MessageSchema);
