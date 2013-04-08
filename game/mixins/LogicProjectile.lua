LogicProjectile = {
    logicProjectileInit = function(self, projectile_modifier)
        self.projectile_modifier = projectile_modifier
        self.instant = projectile_modifier.instant -- done
        self.dot = projectile_modifier.dot -- done
        self.area = projectile_modifier.area
        self.multiple = projectile_modifier.multiple -- done
        self.fork = projectile_modifier.fork -- done
        self.back = projectile_modifier.back -- done
        self.pierce = projectile_modifier.pierce -- done
        self.reflecting = projectile_modifier.reflecting -- done
        self.slow = projectile_modifier.slow -- done
        self.stun = projectile_modifier.stun -- done

        self.enemies_hit = {}
    end,

    addEnemy = function(self, enemy)
        table.insert(self.enemies_hit, enemy)
    end
}
