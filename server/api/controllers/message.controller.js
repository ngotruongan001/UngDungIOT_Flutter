const Message = require('../models/message.model');
const mongoose = require('mongoose');

const message = {
    getMessages: async (req, res) => {
        try {
            const messages = await Message.find().sort(
                '-createdAt',
            );
            return res.status(200).json(messages);
        } catch (err) {
            console.log(err);
            return res.status(500).json({ msg: err.message });
        }
    },
    getMessage: async (req, res) => {
        try {
            const id = req.params.id;
            const message = await Message.findById(id);
            return res.status(200).json(message);
        } catch (err) {
            console.log(err);
            return res.status(500).json({ msg: err.message });
        }
    },
    createMessage: async (req, res) => {
        const newMessage = new Message(req.body);
        try {
            const savedMessage = await newMessage.save();
            res.status(200).json(savedMessage);
        } catch (err) {
            console.log(err);
            res.status(500).json(err);
        }
    },
    updateMessage: async (req, res) => {
        try {
            const id = req.params.id;
            const message = await Message.findById(id);

            const newProduct = await message.updateOne({ $set: {readed: true} });
            res.status(200).json(newProduct);
        } catch (err) {
            console.log(err);
            return res.status(500).json({ msg: err.message });
        }
    },
    deleteMessage: async (req, res) => {
        try {
            const message = await Message.findById(req.params.id);
            await message.deleteOne();
            res.status(200).json(message);
        } catch (err) {
            res.status(500).json(err);
        }
    },
};

module.exports = message;
