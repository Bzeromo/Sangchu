package com.sc.sangchu.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class BookmarkDTO {
    private int coId;
    private String IDFA;
    private boolean bookmark;
    private String memo;
}
