package org.gdsc.globook.presentation.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.gdsc.globook.application.repository.UserRepository;
import org.gdsc.globook.core.annotation.AuthenticationPrincipal;
import org.gdsc.globook.core.common.BaseResponse;
import org.gdsc.globook.core.security.info.JwtToken;
import org.gdsc.globook.core.util.JwtUtil;
import org.gdsc.globook.domain.type.ELanguage;
import org.gdsc.globook.domain.type.ELoginProvider;
import org.gdsc.globook.domain.entity.User;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/test")
@RequiredArgsConstructor
@Slf4j
public class TestController {
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;

    @GetMapping("")
    public ResponseEntity<String> SecurityTest(@AuthenticationPrincipal Long userId) {
        return ResponseEntity.ok("Spring Security + JWT Test " + userId);
    }

    @PostMapping("/sign-up")
    public ResponseEntity<String> signUp() {
        User user = User.create("test", "test", "test", ELanguage.KO, ELoginProvider.DEFAULT);
        userRepository.save(user);
        return ResponseEntity.ok("User Info: " + user.getId());
    }

    @PostMapping("/login")
    public BaseResponse<JwtToken> signIn(@RequestParam String email,
                                         @RequestParam String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        JwtToken jwtToken = jwtUtil.generateToken(user.getId(), user.getRole());

        return BaseResponse.success(jwtToken);
    }
}
