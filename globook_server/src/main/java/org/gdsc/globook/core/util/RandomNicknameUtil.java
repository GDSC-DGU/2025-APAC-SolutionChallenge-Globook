package org.gdsc.globook.core.util;

import java.util.HashSet;
import java.util.Set;
import org.springframework.stereotype.Component;

@Component
public class RandomNicknameUtil {
    private static final String[] adjectives = {
            "Happy", "Brave", "Calm", "Clever", "Jolly", "Bright", "Charming", "Witty", "Noble", "Bold",
            "Lucky", "Swift", "Shiny", "Cool", "Strong", "Quick", "Smart", "Kind", "Loyal", "Neat",
            "Fresh", "Sunny", "Wise", "Zesty", "Snappy", "Dandy", "Feisty", "Breezy", "Zappy", "Peppy",
            "Cheerful", "Gleeful", "Lively", "Proud", "Radiant", "Sincere", "Quirky", "Jazzy", "Merry", "Witty"
    };

    private static final String[] nouns = {
            "Fox", "Wolf", "Cat", "Dog", "Bat", "Hawk", "Bear", "Ant", "Bee", "Duck",
            "Lion", "Tiger", "Shark", "Eagle", "Deer", "Frog", "Fish", "Mouse", "Goat", "Cow",
            "Moose", "Whale", "Crab", "Tuna", "Horse", "Seal", "Otter", "Koala", "Lynx", "Ox",
            "Puma", "Swan", "Mole", "Lamb", "Raven", "Swine", "Gecko", "Panda", "Snail", "Toad"
    };

    private static final Set<String> usedNicknames = new HashSet<>();

    public static String generateRandomNickname() {
        String nickname;
        do {
            int adjectiveIndex = (int) (Math.random() * adjectives.length);
            int nounIndex = (int) (Math.random() * nouns.length);
            nickname = adjectives[adjectiveIndex] + nounCapital(nouns[nounIndex]);
        } while (usedNicknames.contains(nickname) || nickname.length() > 10);
        usedNicknames.add(nickname);
        return nickname;
    }

    private static String nounCapital(String noun) {
        return noun.substring(0, 1).toUpperCase() + noun.substring(1);
    }
}
