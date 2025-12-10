package com.bjb.upmfx.wire;

// Simple record holding an encoder and a decoder
// Either encoder or decoder may be null but not both
public record Codec(Encoder encoder, Decoder decoder) {}
