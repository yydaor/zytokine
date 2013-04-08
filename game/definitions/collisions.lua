function loadCollisions()
    local collision_mask = struct('categories', 'masks')
    collision_masks = {}
    collision_masks['Player'] = collision_mask({1}, {})
    collision_masks['Solid'] = collision_mask({2}, {})
    collision_masks['Projectile'] = collision_mask({3}, {1, 3})
    collision_masks['Enemy'] = collision_mask({4}, {1, 3, 4})
    collision_masks['ItemBox'] = collision_mask({2}, {1, 3, 4})
end
