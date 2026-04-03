function mask = generate_chaos_mask(h, w, state)
    quantized = round(sum(state) * 1e5); 
    seed = uint32(abs(quantized)); 
    rng(seed);
    mask = randi([0, 255], h, w, 3, 'uint8');
end