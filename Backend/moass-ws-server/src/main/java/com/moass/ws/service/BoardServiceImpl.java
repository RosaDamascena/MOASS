package com.moass.ws.service;

import com.moass.ws.dto.BoardEnterDto;
import com.moass.ws.dto.BoardRequestDto;
import com.moass.ws.dto.BoardResponseDto;
import com.moass.ws.dto.MessageDto;
import com.moass.ws.entity.Board;
import com.moass.ws.entity.BoardUser;
import com.moass.ws.entity.User;
import com.moass.ws.repository.BoardRepository;
import com.moass.ws.repository.BoardUserRepository;
import com.moass.ws.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final Map<Integer, MessageDto> boards = new HashMap<>();
    private final SimpMessagingTemplate template;
    private final BoardRepository boardRepository;
    private final UserRepository userRepository;
    private final BoardUserRepository boardUserRepository;

//    public void createBoard(BoardRequestDto dto) {
//        Board board = boardRepository.save(new Board());
//        boardUserRepository.save(new BoardUser(board.getBoardId(), dto.getUserId()));
//
//        Set<User> users = new HashSet<>();
//        users.add(userRepository.findById(dto.getUserId()).orElseThrow());
//        boards.put(board.getBoardId(), users);
//
//        template.convertAndSend("/topic/board/" + board.getBoardId(), BoardResponseDto.builder()
//                .boardId(board.getBoardId())
//                .users(users)
//                .build());
//    }

    public void enterBoard(String message) {
        JSONParser parser = new JSONParser();
        Object obj = null;

        try {
            obj = parser.parse(message);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        JSONObject jsonObject = (JSONObject) obj;
        BoardEnterDto boardEnterDto = new BoardEnterDto((Integer) jsonObject.get("boardId"), (String) jsonObject.get("userId"));

//        boardUserRepository.save(new BoardUser(boardEnterDto.getBoardId(), boardEnterDto.getUserId()));
//        boards.get(boardEnterDto.getBoardId()).getIds().add(boardEnterDto.getUserId());

        template.convertAndSend("/topic/board/" + boardEnterDto.getBoardId(), boards.get(boardEnterDto.getBoardId()));
    }

//    public void quitBoard(BoardRequestDto dto) {
//        boards.get(dto.getBoardId()).remove(userRepository.findById(dto.getUserId()).orElseThrow());
//
//        template.convertAndSend("/topic/board/" + dto.getBoardId(), BoardResponseDto.builder()
//                .boardId(dto.getBoardId())
//                .users(boards.get(dto.getBoardId()))
//                .build());
//    }

    public void drawBoard(String message) {
        template.convertAndSend("/topic/board/draw", message);
    }
}