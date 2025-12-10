package com.bjb.upmfx.wire;

import java.time.LocalTime;

public record MessageRecord(LocalTime localTime, Message message) {}
