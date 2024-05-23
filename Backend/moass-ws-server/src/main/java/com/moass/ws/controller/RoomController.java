package com.moass.ws.controller;

import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;
import com.moass.ws.entity.User;
import com.moass.ws.model.Room;
import com.moass.ws.repository.UserRepository;
import com.moass.ws.service.BoardService;
import com.moass.ws.service.RoomService;
import com.moass.ws.service.UploadService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/v1/board")
@RequiredArgsConstructor
public class RoomController {

    private final RoomService roomService;
    private final BoardService boardService;
    private final UploadService uploadService;
    private final UserRepository userRepository;

    @GetMapping("/create/{userId}")
    public ResponseEntity<String> createBoard(@PathVariable String userId) {
        String url = "https://k10e203.p.ssafy.io/wbo/boards/" + UUID.randomUUID();

        Board board = new Board();
        board.setBoardUrl(url);
        Board received = boardService.createBoard(board);
        Room room = new Room();
        room.setId(received.getBoardId());
        room.setBoardUrl(received.getBoardUrl());
        room.setIsActive(true);
        room.setCompletedAt(received.getCompletedAt());

        boardService.createBoardUser(new BoardUser(board.getBoardId(), userId));

        List<User> userList = new ArrayList<>();
        userList.add(userRepository.findById(userId).orElseThrow());
        room.setParticipants(userList);
        roomService.save(room);

        return ResponseEntity.ok(url);
    }

    @GetMapping("/{boardId}/{userId}")
    public ResponseEntity<String> joinBoard(@PathVariable Integer boardId, @PathVariable String userId) {
        return ResponseEntity.ok(boardService.joinBoard(boardId, userId));
    }

    @GetMapping("/all/{userId}")
    public List<Room> getAllRooms(@PathVariable String userId) {
        return boardService.getBoards(userId);
    }

    @PostMapping("/screenshot")
    public ResponseEntity<String> saveScreenshot(@RequestPart(value = "boardId") Integer boardId, @RequestPart(value = "userId") String userId, @RequestPart(value = "file") MultipartFile file) throws Exception {
        String url = uploadService.uploadFile(boardId, userId, file);
        return ResponseEntity.ok(url);
    }
}
