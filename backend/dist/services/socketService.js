"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.socketHandler = void 0;
const socketHandler = (io) => {
    io.on('connection', (socket) => {
        console.log('User connected:', socket.id);
        // Join user to their couple room when connected
        socket.on('join-couple', (coupleId) => {
            if (coupleId) {
                socket.join(`couple-${coupleId}`);
                console.log(`User ${socket.id} joined couple ${coupleId}`);
            }
        });
        // Handle real-time updates
        socket.on('task-updated', (data) => {
            socket.to(`couple-${data.coupleId}`).emit('task-updated', data);
        });
        socket.on('finance-updated', (data) => {
            socket.to(`couple-${data.coupleId}`).emit('finance-updated', data);
        });
        socket.on('checkin-updated', (data) => {
            socket.to(`couple-${data.coupleId}`).emit('checkin-updated', data);
        });
        socket.on('agenda-updated', (data) => {
            socket.to(`couple-${data.coupleId}`).emit('agenda-updated', data);
        });
        socket.on('note-added', (data) => {
            socket.to(`couple-${data.coupleId}`).emit('note-added', data);
        });
        socket.on('disconnect', () => {
            console.log('User disconnected:', socket.id);
        });
    });
};
exports.socketHandler = socketHandler;
